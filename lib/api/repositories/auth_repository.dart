import 'package:laber_app/api/api_provider.dart';
import 'package:laber_app/api/models/responses/auth/login_response.dart';
import 'package:laber_app/api/models/responses/auth/verify_response.dart';

class AuthRepository extends ApiProvider {
  Future<ApiRepositoryResponse<LoginResponse>> login(String phoneNumber) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'phoneNumber': phoneNumber,
      });

      return ApiRepositoryResponse<LoginResponse>(
        body: LoginResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return ApiRepositoryResponse<LoginResponse>(
        status: 500,
      );
    }
  }

  Future<ApiRepositoryResponse<VerifyResponse>> verify(
      String phoneNumber, String otp) async {
    try {
      final response = await dio.post('/auth/verify', data: {
        'phoneNumber': phoneNumber,
        'otp': otp,
      });

      return ApiRepositoryResponse<VerifyResponse>(
        body: VerifyResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return ApiRepositoryResponse<VerifyResponse>(
        status: 500,
      );
    }
  }
}
