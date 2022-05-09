import 'data/data.dart';
import 'presentation/presentation.dart';

class Feature {
  final String name;
  final Data data;
  final List<Presentation> presentations;

  const Feature({
    required this.name,
    required this.data,
    required this.presentations,
  });

  factory Feature.fromMap(Map<String, dynamic> map) {
    return Feature(
      name: map['name'] as String,
      data: Data.fromMap(map['data'] as Map<String, dynamic>),
      presentations: (map['presentations'] as List<dynamic>)
          .map((e) => Presentation.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'data': this.data.toMap(),
      'presentations': this.presentations.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'Feature{name: $name,'
        ' data: $data,'
        ' presentations: $presentations}';
  }
}
