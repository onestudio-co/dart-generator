class FeatureFlag {
  final String key;

  FeatureFlag({required this.key});

  factory FeatureFlag.fromMap(Map<String, dynamic> map) {
    return FeatureFlag(
      key: map['key'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': this.key,
    };
  }

  @override
  String toString() {
    return 'FeatureFlag{key: $key}';
  }
}
