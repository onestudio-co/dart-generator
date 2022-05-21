import '../factory_visitor.dart';

String create(DartClass dartClass) {
  final className = dartClass.name;
  final createMethodName = 'create$className';
  return '''
    $createMethodName() {
     return $className(${dartClass.allDefaultClassFields});
   }
  if (_count != null) {
    return List<$className>.filled(_count!, $createMethodName());
  } else {
    return $createMethodName();
  }
''';
}
