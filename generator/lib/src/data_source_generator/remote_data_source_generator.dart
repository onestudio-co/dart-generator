import 'dart:io';

import 'package:dcli/dcli.dart';

import '../feature_generator/models/data/data.dart';
import '../helpers/helpers.dart';
import 'remote_data_source_code_builder.dart';

class RemoteDataSourceGenerator {
  final String name;
  final Data data;
  final Directory dataDirectory;

  RemoteDataSourceGenerator({
    required this.name,
    required this.data,
    required this.dataDirectory,
  });

  Future<void> generate() async {
    final remoteDataSourceFileName = name.toSnakeCase() + '.dart';

    final directory = Directory.current;

    final remoteDataSourceFile = directory.search(remoteDataSourceFileName);

    if (remoteDataSourceFile == null) {
      print(yellow(
          'Start Generating File $remoteDataSourceFileName For $name 👀'));
      final dataSourcesDirectory =
          await dataDirectory.createDirectory('data_sources');
      final remoteDataSourceClass =
          RemoteDataSourceCodeBuilder.generateRemoteDataSource(name, data);
      final File file =
          File(dataSourcesDirectory.path + '/$remoteDataSourceFileName');
      await file.writeAsString(remoteDataSourceClass);
      print(green('File $remoteDataSourceFileName For $name Generated 🚀🥳'));
    } else {
      print(grey('File $remoteDataSourceFileName For $name Found'
          ' So No Need To Generate It 💪🏽'));
    }
  }
}
