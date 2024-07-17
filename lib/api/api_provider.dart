import 'package:dio/dio.dart';
export 'api_provider.dart';

abstract class ApiProvider {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080',
  ));
}

class ApiRepositoryResponse<B> {
  B? body;
  int status;

  ApiRepositoryResponse({this.body, required this.status});
}
