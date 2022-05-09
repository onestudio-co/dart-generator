import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:yaml/yaml.dart';

import 'feature_generator/feature_generator.dart';
import 'feature_generator/models/feature.dart';
import 'helpers/helpers.dart';

class MakeFeatureCommand extends Command<Future<void>> {
  @override
  String get name => 'feature';

  @override
  String get description =>
      'generate feature files (data and presentation files) based on some '
      'options and flags';

  MakeFeatureCommand() {
    argParser.addOption(
      'name',
      mandatory: true,
      help:
          'the name of the feature, the generated file names will be specified'
          ' based on the feature name unless one of custom options are'
          ' set (model)',
      valueHelp: '',
    );
    argParser.addOption(
      'model',
      abbr: 'm',
      help: 'custom model name',
    );
  }

  @override
  Future<void> run() async {
    final String featureName = argResults?['name'];
    final featureFileName = featureName.toSnakeCase() + '.yaml';

    print('....');
    final projectName = await Directory.current.getProjectName();
    if (projectName == null) {
      throw Exception('invalid dart project');
    }

    final directory = Directory.current.getLibDirectory();
    if (directory == null) {
      throw Exception('invalid dart project');
    }

    final featureFile = directory.search(featureFileName);

    if (featureFile == null) {
      throw Exception('${featureFileName} file not found 🤷');
    }

    //

    final pubspecFileContent = await featureFile.readAsString();
    final mapData = loadYaml(pubspecFileContent);
    final Feature feature = Feature.fromMap(json.decode(json.encode(mapData)));
    FeatureGenerator(feature, featureFile.parent).generateFeature();
  }
}
