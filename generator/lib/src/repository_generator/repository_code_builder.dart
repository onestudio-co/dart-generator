import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../feature_generator/models/data/data.dart';
import '../helpers/helpers.dart';
import 'stubs/repository_method_stub.dart';

class RepositoryCodeBuilder {
  static generateRepository(
      String repositoryName, String dataSourceName, Data data) {
    final remoteDataSource = Class(
      (b) => b
        ..name = repositoryName
        ..fields.add(
          Field((b) => b
            ..name = 'remoteDataSource'
            ..type = refer(dataSourceName)),
        )
        ..constructors.add(
          Constructor(
            (b) => b
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..name = 'remoteDataSource'
                    ..toThis = true,
                ),
              ),
          ),
        )
        ..methods.addAll(
          data.apis.map(
            (api) => Method(
              (b) => b
                ..name = api.name
                ..modifier = MethodModifier.async
                ..requiredParameters.addAll(
                  (api.values ?? {}).entries.map(
                        (item) => Parameter(
                          (b) => b
                            ..name = item.key.fromSnakeCaseToCamelCase
                            ..type = refer(item.value.runtimeType.text),
                        ),
                      ),
                )
                ..requiredParameters.addAll(
                  (api.body ?? {}).entries.map(
                        (item) => Parameter(
                          (b) => b
                            ..name = item.key.fromSnakeCaseToCamelCase
                            ..type = refer(item.value.runtimeType.text),
                        ),
                      ),
                )
                ..returns = refer('Future<Either<Failure,${api.type}>>')
                ..body = Code(repositoryMethodBody(api)),
            ),
          ),
        ),
    );

    final library = Library(
      (b) => b
        ..directives.addAll(
          [
            Directive.import('package:dartz/dartz.dart'),
            Directive.import('package:famcare/core/models/list_response.dart'),
            Directive.import(
                'package:famcare/core/models/single_response.dart'),
            Directive.import(
                'package:famcare/core/models/success_response.dart'),
            Directive.import('package:famcare/core/errors/exceptions.dart'),
            Directive.import('package:famcare/core/errors/failures.dart'),
            Directive.import(
                '../data_sources/${dataSourceName.toSnakeCase()}.dart'),
          ],
        )
        ..directives.addAll(
          data.apis
              .where((element) => element.model != null)
              .map((element) => element.model)
              .toSet()
              .map(
                (model) => Directive.import(
                  '../models/${model?.toSnakeCase()}.dart',
                ),
              ),
        )
        ..body.addAll(
          [remoteDataSource],
        ),
    );

    final emitter = DartEmitter();
    return DartFormatter().format('${library.accept(emitter)}');
  }
}
