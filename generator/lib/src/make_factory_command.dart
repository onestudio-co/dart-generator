import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import 'factories_generator/factories_generator.dart';
import 'helpers/helpers.dart';

class MakeFactoryCommand extends Command<Future<void>> {
  @override
  String get name => 'factory';

  @override
  String get description =>
      'create factory for model the new factory will placed on "feature/data/factories" folder';

  MakeFactoryCommand() {
    argParser.addOption(
      'name',
      abbr: 'f',
      mandatory: true,
    );
  }

  Future<void> run() async {
    final String factoryName = argResults?['name'];
    final modelFileName =
        factoryName.replaceAll('Factory', '').toSnakeCase() + '.dart';

    print('....');
    final projectName = await Directory.current.getProjectName();
    if (projectName == null) {
      throw Exception('invalid dart project');
    }

    final directory = Directory.current.getLibDirectory();
    if (directory == null) {
      throw Exception('invalid dart project');
    }

    final modelFile = directory.search(modelFileName);
    final otherRelatedFile = directory.allModels();

    if (modelFile == null) {
      throw Exception('${modelFileName} file not found 🤷');
    }

    print(yellow('Start Generating factory for ${modelFileName} 🚀'));
    await FactoryGenerator.generateFactory(
      projectName: projectName,
      factoryName: factoryName,
      dataDirectory: modelFile.parent.parent,
      modelFile: modelFile,
      otherRelatedFiles: otherRelatedFile,
    );
    print(green('Done 🥳'));
  }
}
