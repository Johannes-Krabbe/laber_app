import 'package:dio/dio.dart';
import 'package:laber_app/api/api_provider.dart';
import 'package:laber_app/api/models/responses/auth/login_response.dart';
import 'package:laber_app/api/models/responses/auth/me_response.dart';
import 'package:laber_app/api/models/responses/auth/verify_response.dart';

class AuthRepository extends ApiProvider {
  Future<ApiRepositoryResponse<AuthLoginResponse>> login(
      String phoneNumber) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'phoneNumber': phoneNumber,
        },
      );

      return ApiRepositoryResponse<AuthLoginResponse>(
        body: AuthLoginResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return ApiRepositoryResponse<AuthLoginResponse>(
        status: 500,
      );
    }
  }

  Future<ApiRepositoryResponse<AuthVerifyResponse>> verify(
      String phoneNumber, String otp) async {
    try {
      final response = await dio.post('/auth/verify', data: {
        'phoneNumber': phoneNumber,
        'otp': otp,
      });

      return ApiRepositoryResponse<AuthVerifyResponse>(
        body: AuthVerifyResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return ApiRepositoryResponse<AuthVerifyResponse>(
        status: 500,
      );
    }
  }

  Future<ApiRepositoryResponse<AuthMeResponse>> fetchMe(String token) async {
    try {
      final response = await dio.get(
        '/auth/me',
        options: Options(headers: {"authorization": "Bearer $token"}),
      );

      return ApiRepositoryResponse<AuthMeResponse>(
        body: AuthMeResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return ApiRepositoryResponse<AuthMeResponse>(
        status: 500,
      );
    }
  }
}
