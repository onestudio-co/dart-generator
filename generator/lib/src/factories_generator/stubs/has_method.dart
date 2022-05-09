import '../factory_visitor.dart';

String hasModel(ClassField classField) => '''
 this.${classField.name} = ${classField.name};
 return this;
''';

String hasModelWithParams(ClassField classField) => '''
 if (${classField.name} != null) {
    this.${classField.name} = ${classField.name};
 } else {
   ${classField.isList ? ' assert(count != null);' : ''}
   this.${classField.name} = ${factoryType(classField)}${classField.isList ? ' .count(count!)' : ''}.create(${factoryParams(classField)});
 }
 return this;
''';

String factoryType(ClassField classField) {
  return classField.isList
      ? classField.typeArguments.first + 'Factory()'
      : classField.type + 'Factory()';
}

String factoryParams(ClassField classField) {
  assert(classField.dartClass != null);
  return classField.dartClass!.fields
      .map((innerClassField) =>
          '${innerClassField.name}: ${innerClassField.name},')
      .toList()
      .join();
}
