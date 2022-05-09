import '../../feature_generator/models/data/api.dart';

String remoteDataSourceMethodBody(Api api) {
  return '''
      final response = await client.get(
      \'${api.pathWithParameters}\',
      headers: Api.headers(),
    );
    if ((response.statusCode ?? 0) <= 204) {
      return ${api.type}.fromResponse(response.data);
    } else {
      throw ServerException.fromResponse(response.data);
    }
''';
}
