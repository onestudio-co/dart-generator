class Event {
  final String name;
  final List<String> params;

  Event({
    required this.name,
    required this.params,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      name: map['name'] as String,
      params: map['params'] == null
          ? []
          : (map['params'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'params': this.params,
    };
  }

  @override
  String toString() {
    return 'Event{name: $name,'
        ' params: $params}';
  }
}
