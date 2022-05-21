import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../helpers/helpers.dart';

typedef DartClassFinder = DartClass? Function(
    FactoryVisitor visitor, String model, bool ignoreImport);

class FactoryVisitor extends RecursiveAstVisitor<void> {
  final DartClassFinder? getDartClass;
  final dartClass = DartClass();

  FactoryVisitor({this.getDartClass});

  @override
  void visitExtendsClause(ExtendsClause node) {
    super.visitExtendsClause(node);
    final parentDartClass =
        getDartClass?.call(this, node.superclass.name.name, true);
    dartClass.fields.addAll(parentDartClass?.fields ?? []);
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);
    dartClass.name = node.name.name;
  }

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    super.visitFieldDeclaration(node);
    for (final field in node.fields.variables) {
      if (node.fields.type == null) {
        throw Exception('models fields must have an explicit type');
      }
      if (node.fields.isConst) {
        return;
      }
      final namedType = node.fields.type as NamedType;
      var type = namedType.name.name;
      final typeArgumentsSource = namedType.typeArguments?.toSource();
      if (typeArgumentsSource != null) {
        type = '$type$typeArgumentsSource';
      }
      final typeArguments = typeArgumentsSource != null
          ? <String>[
              typeArgumentsSource.replaceAll('<', '').replaceAll('>', '')
            ]
          : <String>[];
      dartClass.fields.add(
        ClassField(
          name: field.name.name,
          type: '${type}',
          typeArguments: typeArguments,
          defaultValue: fakerDefaultValue(
            name: field.name.name,
            typeArguments: typeArguments,
            type: type,
          ),
          dartClass: getDartClass?.call(
            this,
            typeArguments.isNotEmpty ? typeArguments.first : type,
            false,
          ),
        ),
      );
    }
  }

  String fakerDefaultValue(
      {required String name,
      required List<String> typeArguments,
      required String type}) {
    if (type.startsWith('List')) {
      if (typeArguments.first == 'int') {
        return 'faker.randomGenerator.numbers(32, 32)';
      } else if (typeArguments.first == 'String') {
        return 'faker.randomGenerator.amount((i) => faker.randomGenerator.string(12), 12)';
      } else if (type == 'double') {
        return 'faker.randomGenerator.amount((i) => faker.randomGenerator.decimal(), 32)';
      } else if (type == 'bool') {
        return 'faker.randomGenerator.amount((i) => faker.randomGenerator.boolean(), 12)';
      } else {
        return '${typeArguments.first}Factory().count(10).create()';
      }
    } else if (type == 'int') {
      return 'faker.randomGenerator.integer(2)';
    } else if (type == 'double') {
      return 'faker.randomGenerator.decimal()';
    } else if (type == 'bool') {
      return 'faker.randomGenerator.boolean()';
    } else if (type == 'String') {
      return 'faker.randomGenerator.string(23)';
    } else if (type == 'DateTime') {
      return 'faker.date.dateTime()';
    } else {
      return '${type}Factory().create()';
    }
  }
}

class DartClass {
  late String name;
  late List<ClassField> fields = [];
  late List<String> imports = [];

  @override
  String toString() {
    return 'DartClass{classFields: $fields}';
  }

  String get allDefaultClassFields => fields
      .map((classField) =>
          '${classField.name}: ${classField.name} ?? this.${classField.name} ?? ${classField.defaultValue},')
      .toList()
      .join();

  String get allStateClassFields => fields
      .map((classField) =>
          'this.${classField.name} = ${classField.name} ?? this.${classField.name};')
      .toList()
      .join();

  List<ClassField> get nonPreemptiveClassFields => fields
      .where(
        (classField) => classField.type.isNonPreemptive,
      )
      .toList();
}

class ClassField {
  final String name;
  final String type;
  final List<String> typeArguments;
  final String defaultValue;
  final DartClass? dartClass;

  ClassField({
    required this.name,
    required this.type,
    this.typeArguments = const [],
    required this.defaultValue,
    this.dartClass,
  });

  ClassField copyWith({
    String? name,
    String? type,
    List<String>? typeArguments,
    String? defaultValue,
    DartClass? dartClass,
  }) {
    return ClassField(
      name: name ?? this.name,
      type: type ?? this.type,
      typeArguments: typeArguments ?? this.typeArguments,
      defaultValue: defaultValue ?? this.defaultValue,
      dartClass: dartClass ?? this.dartClass,
    );
  }

  @override
  String toString() {
    return 'ClassField{name: $name,'
        ' type: $type,'
        ' typeArguments: $typeArguments,'
        ' defaultValue: $defaultValue,'
        ' dartClass: $dartClass}';
  }

  bool get isList => type.startsWith('List<');
}
