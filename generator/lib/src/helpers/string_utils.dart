extension StringUtils on String {
  bool get isNonPreemptive =>
      this != 'int' &&
      this != 'double' &&
      this != 'num' &&
      this != 'bool' &&
      this != 'String' &&
      this != 'DateTime';

  String toSnakeCase() {
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');
    return replaceAllMapped(
      exp,
      (Match matcher) => ('_' + (matcher.group(0) ?? '')),
    ).toLowerCase();
  }

  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toFirsCharLowerCase() =>
      length > 0 ? '${this[0].toLowerCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  String get snakeCase {
    final splitResults = split(' ');
    final results = <String>[];
    int index = 0;
    for (String string in splitResults) {
      results.add(string.toFirsCharLowerCase() + '_');
      index = index + 1;
    }
    return results.join();
  }

  String get fromSnakeCaseToPascalCase {
    final splitResults = split('_');
    final results = <String>[];
    int index = 0;
    for (String string in splitResults) {
      results.add(string.toCapitalized());
      index = index + 1;
    }
    return results.join();
  }

  String get fromSnakeCaseToCamelCase {
    final splitResults = split('_');
    final results = <String>[];
    int index = 0;
    for (String string in splitResults) {
      if (index == 0) {
        results.add(string);
      } else {
        results.add(string.toCapitalized());
      }
      index = index + 1;
    }
    return results.join();
  }
}
