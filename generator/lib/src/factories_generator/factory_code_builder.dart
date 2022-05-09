import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../helpers/helpers.dart';
import 'factory_visitor.dart';
import 'stubs/stubs.dart';

class FactoryCodeBuilder {
  static String buildFactory(String factoryName, DartClass dartClass) {
    final userFactory = Class(
      (b) => b
        ..name = factoryName
        ..fields.addAll(
          dartClass.fields.map(
            (classField) => Field(
              (b) => b
                ..name = classField.name
                ..type = refer(classField.type + '?'),
            ),
          ),
        )
        ..fields.add(
          Field(
            (b) => b
              ..name = '_count'
              ..type = refer('int?'),
          ),
        )
        ..methods.addAll(
          [
            Method(
              (b) => b
                ..name = 'create'
                ..returns = refer('dynamic')
                ..optionalParameters.addAll(
                  dartClass.fields.map(
                    (classField) => Parameter(
                      (b) => b
                        ..required = false
                        ..name = classField.name
                        ..type = refer(classField.type + '?')
                        ..named = true,
                    ),
                  ),
                )
                ..body = Code(create(dartClass)),
            ),
            Method(
              (b) => b
                ..name = 'state'
                ..returns = refer(factoryName)
                ..optionalParameters.addAll(
                  dartClass.fields.map(
                    (classField) => Parameter(
                      (b) => b
                        ..required = false
                        ..name = classField.name
                        ..type = refer(classField.type + '?')
                        ..named = true,
                    ),
                  ),
                )
                ..body = Code(
                  dartClass.allStateClassFields + '\nreturn this;',
                ),
            ),
            Method(
              (b) => b
                ..name = 'count'
                ..returns = refer(factoryName)
                ..requiredParameters.add(
                  Parameter((b) => b
                    ..required = false
                    ..name = 'count'
                    ..type = refer('int')),
                )
                ..body = Code(
                  '''
                  _count = count;
                  return this;
                  ''',
                ),
            ),
          ],
        )
        ..methods.addAll(
          dartClass.nonPreemptiveClassFields.map(
            (classField) => Method(
              (b) => b
                ..name = 'has${classField.name.toTitleCase()}'
                ..returns = refer(factoryName)
                ..optionalParameters.add(
                  Parameter(
                    (b) => b
                      ..required = false
                      ..name = classField.name
                      ..type = refer(classField.type + '?'),
                  ),
                )
                ..optionalParameters.addAll(
                  [
                    if (classField.isList && classField.dartClass != null)
                      Parameter(
                        (b) => b
                          ..named = true
                          ..required = false
                          ..name = 'count'
                          ..type = refer('int?'),
                      )
                  ],
                )
                ..optionalParameters.addAll(
                  (classField.dartClass?.fields ?? [])
                      .map(
                        (innerClassField) => Parameter(
                          (b) => b
                            ..named = true
                            ..required = false
                            ..name = innerClassField.name
                            ..type = refer(innerClassField.type + '?'),
                        ),
                      )
                      .toList(),
                )
                ..body = Code(
                  classField.dartClass == null
                      ? hasModel(classField)
                      : hasModelWithParams(classField),
                ),
            ),
          ),
        ),
    );
    final library = Library(
      (b) => b
        ..directives.addAll(
          dartClass.imports.map(
            (import) => Directive.import(import),
          ),
        )
        ..directives.add(
          Directive.import('package:faker/faker.dart'),
        )
        ..body.addAll(
          [userFactory],
        ),
    );
    final emitter = DartEmitter();
    return DartFormatter().format('${library.accept(emitter)}');
  }
}
