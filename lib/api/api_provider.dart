import 'package:dio/dio.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';
export 'api_provider.dart';

final Dio globalDio = Dio(
  BaseOptions(
    baseUrl: 'http://localhost:8080',
  ),
);

final Dio globalDioAuth = Dio(
  BaseOptions(
    baseUrl: 'http://localhost:8080',
  ),
)..interceptors.add(AuthInterceptor());

var refetchToken = false;

dioRefetchTokenFunction() {
  refetchToken = true;
}

abstract class ApiProvider {
  final dio = globalDio;
  final dioAuth = globalDioAuth;
}

class ApiRepositoryResponse<B> {
  B? body;
  int status;

  ApiRepositoryResponse({this.body, required this.status});
}

class ApiRepositoryResponseError {
  String message;
  int status;

  ApiRepositoryResponseError({required this.message, required this.status});
}

class AuthInterceptor extends Interceptor {
  String? token;
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (token == null || refetchToken) {
      print('refetchToken');
      var secureStorageToken =
          (await AuthStateStoreService.readFromSecureStorage())?.token;
      if (secureStorageToken?.isNotEmpty == true) {
        token = secureStorageToken!;
      } else {
        throw Exception('Token not found');
      }
      refetchToken = false;
    }

    options.headers['Authorization'] = 'Bearer $token';

    super.onRequest(options, handler);
  }
}
