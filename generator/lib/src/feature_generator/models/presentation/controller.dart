class Controller {
  final String initialApi;
  final List<String> apis;

  Controller({
    required this.initialApi,
    required this.apis,
  });

  factory Controller.fromMap(Map<String, dynamic> map) {
    return Controller(
      initialApi: map['initial_api'] as String,
      apis:  map['apis'] == null ? [] : (map['apis'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'initial_api': this.initialApi,
      'apis': this.apis,
    };
  }

  @override
  String toString() {
    return 'Controllers{initialApi: $initialApi,'
        ' apis: $apis}';
  }
}
