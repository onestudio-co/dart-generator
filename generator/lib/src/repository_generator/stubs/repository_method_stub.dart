import '../../feature_generator/models/data/api.dart';
import '../../helpers/helpers.dart';

String repositoryMethodBody(Api api) {
  var parameters = '';
  for (final value in (api.values ?? {}).entries) {
    parameters = parameters + value.key.fromSnakeCaseToCamelCase + ',';
  }
  for (final value in (api.body ?? {}).entries) {
    parameters = parameters + value.key.fromSnakeCaseToCamelCase + ',';
  }
  return '''
       try {
      final response =
          await remoteDataSource.${api.name}($parameters);
      return Right(response);
    } on ServerException catch (e) {
      return Left(e.toFailure());
    } catch (error) {
      return Left(ConnectionFailure());
    }
''';
}
