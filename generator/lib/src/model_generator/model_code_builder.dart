import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../helpers/helpers.dart';

class ModelCodeBuilder {
  static String generateModelClass(
      String modelName, Map<String, dynamic> mappedResponse) {
    final model = Class(
      (b) => b
        ..name = modelName
        ..fields.addAll(
          mappedResponse.entries.map(
            (item) => Field(
              (b) => b
                ..name = item.key.fromSnakeCaseToCamelCase
                ..type = refer(item.value.runtimeType.text)
                ..modifier = FieldModifier.final$,
            ),
          ),
        )
        ..constructors.addAll(
          [
            Constructor(
              (b) => b
                ..optionalParameters.addAll(
                  mappedResponse.entries.map(
                    (item) => Parameter(
                      (b) => b
                        ..name = item.key.fromSnakeCaseToCamelCase
                        ..required = true
                        ..named = true
                        ..toThis = true,
                    ),
                  ),
                ),
            ),
            Constructor(
              (b) => b
                ..factory = true
                ..name = 'fromJson'
                ..requiredParameters.add(
                  Parameter(
                    (b) => b
                      ..name = 'json'
                      ..type = refer('Map<String,dynamic>'),
                  ),
                )
                ..body = Code(
                  '''return $modelName(
                ${mappedResponse.entries.map(
                        (item) => '${item.key.fromSnakeCaseToCamelCase}:'
                            ' json[\'${item.key}\'] '
                            '${item.value.runtimeType.asCasting}',
                      ).toList().join(',')}                      
                  );
            ''',
                ),
            ),
          ],
        )
        ..methods.add(
          Method(
            (b) => b
              ..name = 'toJson'
              ..returns = refer('Map<String, dynamic>')
              ..body = Code('''
                  return {
                  ${mappedResponse.entries.map(
                        (item) => '\'${item.key}\':'
                            '${item.key.fromSnakeCaseToCamelCase}',
                      ).toList().join(',')}
                  };
                  '''),
          ),
        ),
    );
    final emitter = DartEmitter();
    return DartFormatter().format('${model.accept(emitter)}');
  }
}
