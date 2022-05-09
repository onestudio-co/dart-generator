import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../feature_generator/models/data/event.dart';

class EventCodeBuilder {
  static generateEvent(String eventName, Event event) {
    final remoteDataSource = Class((b) => b
      ..name = eventName
      ..extend = refer('AnalyticsEvent')
      ..fields.add(
        Field(
          (b) => b
            ..name = 'key'
            ..type = refer('String')
            ..annotations.add(refer('override'))
            ..assignment = Code('\'${event.name}\''),
        ),
      )
      ..fields.add(
        Field(
          (b) => b
            ..name = 'params'
            ..type = refer('Map<String, dynamic>')
            ..annotations.add(refer('override'))
            ..assignment =
                Code('{${event.params.map((e) => '\'$e\':${'\'TODO: replace'
                    ' it with the real value\''}').toList().join(',')}}'),
        ),
      ));

    final library = Library(
      (b) => b
        ..directives.addAll(
          [
            Directive.import(
              'package:famcare/core/analytics/core/analytics_event.dart',
            ),
          ],
        )
        ..body.addAll(
          [remoteDataSource],
        ),
    );

    final emitter = DartEmitter();
    return DartFormatter().format('${library.accept(emitter)}');
  }
}
