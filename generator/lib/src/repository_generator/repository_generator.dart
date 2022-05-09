import 'dart:io';

import 'package:dcli/dcli.dart';

import '../feature_generator/models/data/data.dart';
import '../helpers/helpers.dart';
import 'repository_code_builder.dart';

class RepositoryGenerator {
  final String name;
  final String dataSourceName;
  final Data data;
  final Directory dataDirectory;

  RepositoryGenerator({
    required this.name,
    required this.dataSourceName,
    required this.data,
    required this.dataDirectory,
  });

  Future<void> generate() async {
    final repositoryFileName = name.toSnakeCase() + '.dart';

    final directory = Directory.current;

    final repositoryFile = directory.search(repositoryFileName);

    if (repositoryFile == null) {
      print(yellow('Start Generating File $repositoryFileName For $name 👀'));
      final repositoryDirectory =
          await dataDirectory.createDirectory('repositories');
      final repositoryClass =
          RepositoryCodeBuilder.generateRepository(name, dataSourceName, data);
      final File file = File(repositoryDirectory.path + '/$repositoryFileName');
      await file.writeAsString(repositoryClass);
      print(green('File $repositoryFileName For $name Generated 🚀🥳'));
    } else {
      print(grey('File $repositoryFileName For $name Found'
          ' So No Need To Generate It 💪🏽'));
    }
  }
}
