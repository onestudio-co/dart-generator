import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../feature_generator/models/data/data.dart';
import '../helpers/helpers.dart';
import 'stubs/remote_data_source_method_stub.dart';

class RemoteDataSourceCodeBuilder {
  static String generateRemoteDataSource(
      String dataSourceName, final Data data) {
    final remoteDataSource = Class(
      (b) => b
        ..name = dataSourceName
        ..fields.add(
          Field((b) => b
            ..name = 'client'
            ..type = refer('ApiClient')),
        )
        ..extend = refer('DataSource')
        ..constructors.add(
          Constructor(
            (b) => b
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..name = 'client'
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
                ..returns = refer('Future<${api.type}>')
                ..body = Code(remoteDataSourceMethodBody(api)),
            ),
          ),
        ),
    );

    final library = Library(
      (b) => b
        ..directives.addAll(
          [
            Directive.import('package:famcare/core/api_client.dart'),
            Directive.import('package:famcare/core/data_soruce.dart'),
            Directive.import('package:famcare/core/models/list_response.dart'),
            Directive.import(
                'package:famcare/core/models/single_response.dart'),
            Directive.import(
                'package:famcare/core/models/success_response.dart'),
            Directive.import('package:famcare/constants.dart'),
            Directive.import('package:famcare/core/errors/exceptions.dart'),
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
