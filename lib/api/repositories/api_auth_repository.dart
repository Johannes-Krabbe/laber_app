import 'package:dio/dio.dart';
import 'package:laber_app/api/api_errors.dart';
import 'package:laber_app/api/api_provider.dart';
import 'package:laber_app/api/models/responses/auth/login_response.dart';
import 'package:laber_app/api/models/responses/auth/me_response.dart';
import 'package:laber_app/api/models/responses/auth/me_update_response.dart';
import 'package:laber_app/api/models/responses/auth/verify_response.dart';

class ApiAuthRepository extends ApiProvider {
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
      return parseError(e);
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
      return parseError(e);
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
      return parseError(e);
    }
  }

  Future<ApiRepositoryResponse<MeUpdateResponse>> updateMe({
    String? token,
    String? username,
    String? name,
    String? phoneNumber,
    bool? phoneNumberDiscoveryEnabled,
    bool? usernameDiscoveryEnabled,
  }) async {
    try {
      Response<dynamic> response;
      if (token == null) {
        response = await dioAuth.put(
          '/auth/me/update',
          data: {
            'username': username,
            'name': name,
            'phoneNumber': phoneNumber,
            'phoneNumberDiscoveryEnabled': phoneNumberDiscoveryEnabled,
            'usernameDiscoveryEnabled': usernameDiscoveryEnabled,
          },
        );
      } else {
        response = await dio.put(
          '/auth/me/update',
          options: Options(headers: {"authorization": "Bearer $token"}),
          data: {
            'username': username,
            'name': name,
            'phoneNumber': phoneNumber,
            'phoneNumberDiscoveryEnabled': phoneNumberDiscoveryEnabled,
            'usernameDiscoveryEnabled': usernameDiscoveryEnabled,
          },
        );
      }

      return ApiRepositoryResponse<MeUpdateResponse>(
        body: MeUpdateResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return parseError(e);
    }
  }
}
