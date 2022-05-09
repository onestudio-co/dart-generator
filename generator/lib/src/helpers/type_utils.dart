extension TypeUtils on Type {
  String get text {
    if (toString() == 'Null') {
      return 'dynamic';
    }
    return toString();
  }

  String get asCasting {
    if (toString() == 'Null') {
      return '';
    }
    return 'as ${text}';
  }
}
