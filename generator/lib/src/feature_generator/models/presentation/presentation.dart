import 'controller.dart';
import 'feature_flag.dart';

class Presentation {
  final String name;
  final List<Controller> controllers;
  final FeatureFlag? featureFlag;
  final bool generateRoute;

  Presentation({
    required this.name,
    required this.controllers,
    this.featureFlag,
    required this.generateRoute,
  });

  factory Presentation.fromMap(Map<String, dynamic> map) {
    return Presentation(
      name: map['name'] as String,
      controllers: map['controllers'] == null
          ? []
          : (map['controllers'] as List<dynamic>)
              .map((e) => Controller.fromMap(e))
              .toList(),
      featureFlag: map['feature_flag'] == null
          ? null
          : FeatureFlag.fromMap(map['feature_flag']),
      generateRoute: map['generate_route'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'controllers': this.controllers.map((e) => e.toMap()).toList(),
      'feature_flag': this.featureFlag?.toMap(),
      'generate_route': this.generateRoute,
    };
  }

  @override
  String toString() {
    return 'Presentations{name: $name,'
        ' controllers: $controllers,'
        ' featureFlag: $featureFlag,'
        ' generateRoute: $generateRoute}';
  }
}
