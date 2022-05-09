import 'dart:convert';
import 'dart:io';

import 'package:dcli/dcli.dart';

import '../helpers/helpers.dart';
import 'model_code_builder.dart';

class ModelGenerator {
  final String modelName;
  final String response;
  final Directory dataDirectory;

  ModelGenerator(this.modelName, this.response, this.dataDirectory);

  Future<void> generateModel() async {
    final mappedResponse = json.decode(response);
    final modelFileName = modelName.toSnakeCase() + '.dart';

    final directory = Directory.current;

    final modelFile = directory.search(modelFileName);

    if (modelFile == null) {
      print(yellow('Start Generating File $modelFileName For $modelName 👀'));
      String? modelClass;
      if (mappedResponse['data'] is List<dynamic>) {
        final responseList = mappedResponse['data'] as List<dynamic>;
        if (responseList.isNotEmpty) {
          modelClass = ModelCodeBuilder.generateModelClass(
              modelName, responseList.first);
        }
      } else {
        modelClass = ModelCodeBuilder.generateModelClass(
            modelName, mappedResponse['data']);
      }
      if (modelClass != null) {
        final modelsDirectory = await dataDirectory.createDirectory('models');
        final File file = File(modelsDirectory.path + '/$modelFileName');
        await file.writeAsString(modelClass);
        print(green('File $modelFileName '
            'For $modelName Generated 🚀🥳'));
      }
    } else {
      print(grey('File $modelFileName For $modelName Found'
          ' So No Need To Generate It 💪🏽'));
    }
  }
}
