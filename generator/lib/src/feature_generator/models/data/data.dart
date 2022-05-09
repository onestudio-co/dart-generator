import 'api.dart';
import 'event.dart';

class Data {
  final String baseUrl;
  final Map<String, String> headers;
  final List<Api> apis;
  final bool createRepo;
  final List<Event> events;

  Data({
    required this.baseUrl,
    required this.headers,
    required this.apis,
    required this.createRepo,
    required this.events,
  });

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      baseUrl: map['base_url'] as String,
      headers: map['headers'] == null
          ? {}
          : (map['headers'] as Map<String, dynamic>).cast(),
      apis: (map['apis'] as List<dynamic>).map((e) => Api.fromMap(e)).toList(),
      createRepo: map['create_repo'] as bool? ?? false,
      events: (map['events'] as List<dynamic>)
          .map((e) => Event.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'base_url': this.baseUrl,
      'headers': this.headers,
      'apis': this.apis.map((e) => e.toMap()).toList(),
      'create_repo': this.createRepo,
      'events': this.events.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'Data{baseUrl: $baseUrl,'
        ' headers: $headers,'
        ' apis: $apis,'
        ' createRepo: $createRepo,'
        ' events: $events}';
  }
}
