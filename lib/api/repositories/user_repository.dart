import 'package:dio/dio.dart';
import 'package:laber_app/api/api_provider.dart';
import 'package:laber_app/api/models/responses/user/discover/phone_number.dart';
import 'package:laber_app/api/models/responses/user/get_by_id.dart';

class UserRepository extends ApiProvider {
  Future<ApiRepositoryResponse<UserDiscoverPhoneNumberResponse>>
      discoverByPhoneNumber(String phoneNumberHash) async {
    try {
      final response = await dioAuth.post(
        '/user/discover/phone-number',
        data: {
          'phoneNumberHash': phoneNumberHash,
        },
      );

      return ApiRepositoryResponse<UserDiscoverPhoneNumberResponse>(
        body: UserDiscoverPhoneNumberResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      if (e is DioException) {
        return ApiRepositoryResponse<UserDiscoverPhoneNumberResponse>(
          body:
              UserDiscoverPhoneNumberResponse.fromJson(e.response?.data ?? {}),
          status: e.response?.statusCode ?? 500,
        );
      }
      return ApiRepositoryResponse<UserDiscoverPhoneNumberResponse>(
        status: 500,
      );
    }
  }

  Future<ApiRepositoryResponse<UserGetByIdResponse>> getById(
      String userId) async {
    try {
      final response = await dioAuth.get(
        '/user/$userId',
      );

      return ApiRepositoryResponse<UserGetByIdResponse>(
        body: UserGetByIdResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      if (e is DioException) {
        return ApiRepositoryResponse<UserGetByIdResponse>(
          body: UserGetByIdResponse.fromJson(e.response?.data ?? {}),
          status: e.response?.statusCode ?? 500,
        );
      }
      return ApiRepositoryResponse<UserGetByIdResponse>(
        status: 500,
      );
    }
  }
}
