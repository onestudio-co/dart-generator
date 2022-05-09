class Api {
  final String name;
  final String method;
  final String path;
  final Map<String, dynamic>? values;
  final Map<String, dynamic>? body;
  final String responseModel;
  final String? model;

  const Api({
    required this.name,
    required this.method,
    required this.path,
    this.values,
    this.body,
    required this.responseModel,
    this.model,
  });

  factory Api.fromMap(Map<String, dynamic> map) {
    return Api(
      name: map['name'] as String,
      method: map['method'] as String,
      path: map['path'] as String,
      values:
          map['values'] == null ? null : map['values'] as Map<String, dynamic>,
      body: map['body'] == null ? null : map['body'] as Map<String, dynamic>,
      responseModel: map['response_model'] as String,
      model: map['model'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'method': this.method,
      'path': this.path,
      'values': this.values,
      'body': this.body,
      'response_model': this.responseModel,
      'model': this.model,
    };
  }

  @override
  String toString() {
    return 'Api{name: $name,'
        ' method: $method,'
        ' path: $path,'
        ' values: $values,'
        ' body: $body,'
        ' responseModel: $responseModel,'
        ' model: $model}';
  }

  String get pathWithValues {
    String modifiedPath = path;
    values?.forEach((key, value) {
      modifiedPath = modifiedPath.replaceFirst(
        key,
        value.toString(),
      );
    });
    return modifiedPath;
  }

  String get pathWithParameters {
    String modifiedPath = path;
    values?.forEach((key, value) {
      modifiedPath = modifiedPath.replaceFirst(
        key,
        '\$${key}',
      );
    });
    return modifiedPath;
  }

  String get type =>
      model == null ? '${responseModel}' : '${responseModel}<${model}>';
}
