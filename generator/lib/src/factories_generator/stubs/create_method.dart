import '../factory_visitor.dart';

String create(DartClass dartClass) {
  final className = dartClass.name;
  final variableName = 'm${dartClass.name}';
  return '''
  final $variableName = $className(${dartClass.allDefaultClassFields});
  if (_count != null) {
    return List<$className>.filled(_count!, $variableName);
  } else {
    return $variableName;
  }
''';
}
