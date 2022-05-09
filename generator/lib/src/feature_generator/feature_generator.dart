import 'dart:io';

import 'package:dcli/dcli.dart';

import '../data_source_generator/remote_data_source_generator.dart';
import '../events_generator/events_generator.dart';
import '../helpers/helpers.dart';
import '../model_generator/model_generator.dart';
import '../repository_generator/repository_generator.dart';
import 'api_fetcher.dart';
import 'models/feature.dart';

class FeatureGenerator {
  final Feature feature;
  final Directory featureDirectory;

  FeatureGenerator(this.feature, this.featureDirectory);

  Future<void> generateFeature() async {
    try {
      final dataDirectory = await featureDirectory.createDirectory('data');
      await generateModels(dataDirectory);
      await generateRemoteDataSource(dataDirectory);
      await generateRepository(dataDirectory);
      await generateEvents(dataDirectory);
    } catch (error) {
      print(red('Error while generating ${feature.name} $error'));
    }
  }

  Future<void> generateModels(Directory dataDirectory) async {
    print(yellow('Start Generating Models ..'));
    final ApiFetcher apiFetcher = ApiFetcher(
      feature.data.baseUrl,
      feature.data.headers,
    );
    for (final api in feature.data.apis) {
      print('feature api $api');
      final response = await apiFetcher.fetch(api);
      if (api.model == null) continue;
      final modelGenerator = ModelGenerator(
        api.model!,
        response,
        dataDirectory,
      );
      await modelGenerator.generateModel();
    }
  }

  Future<void> generateRemoteDataSource(Directory dataDirectory) async {
    print(yellow('Start Generating Remote Data Source'));
    final remoteDataSourceGenerator = RemoteDataSourceGenerator(
      name: feature.name.fromSnakeCaseToPascalCase + 'RemoteDataSource',
      data: feature.data,
      dataDirectory: dataDirectory,
    );
    await remoteDataSourceGenerator.generate();
  }

  Future<void> generateRepository(Directory dataDirectory) async {
    print(yellow('Start Generating Repository'));
    final repositoryGenerator = RepositoryGenerator(
      name: feature.name.fromSnakeCaseToPascalCase + 'Repository',
      dataSourceName:
          feature.name.fromSnakeCaseToPascalCase + 'RemoteDataSource',
      data: feature.data,
      dataDirectory: dataDirectory,
    );
    await repositoryGenerator.generate();
  }

  Future<void> generateEvents(Directory dataDirectory) async {
    print(yellow('Start Generating Events'));
    final eventsGenerator = EventsGenerator(
      dataDirectory: dataDirectory,
      events: feature.data.events,
    );
    await eventsGenerator.generate();
  }
}
