import 'package:dio/dio.dart';
import 'package:laber_app/api/api_errors.dart';
import 'package:laber_app/api/api_provider.dart';
import 'package:laber_app/api/models/responses/device/create.dart';
import 'package:laber_app/api/models/responses/device/get_all.dart';
import 'package:laber_app/api/models/responses/device/get_ids.dart';
import 'package:laber_app/api/models/responses/device/get_key_bundle.dart';
import 'package:laber_app/api/models/responses/device/get_public.dart';

class ApiDeviceRepository extends ApiProvider {
  Future<ApiRepositoryResponse<DeviceCreateResponse>> create(
    String token, {
    required String deviceName,
    required String identityKey,
    required Map<String, String> signedPreKey,
    required List<String> oneTimePreKeys,
  }) async {
    try {
      final response = await dio.post('/device',
          data: {
            'deviceName': deviceName,
            'identityKey': identityKey,
            'signedPreKey': signedPreKey,
            'oneTimePreKeys': oneTimePreKeys,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));

      return ApiRepositoryResponse<DeviceCreateResponse>(
        body: DeviceCreateResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return parseError(e);
    }
  }

  Future<ApiRepositoryResponse<DeviceGetAllResponse>> getAll() async {
    try {
      final response = await dioAuth.get('/device/all');

      return ApiRepositoryResponse<DeviceGetAllResponse>(
        body: DeviceGetAllResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return parseError(e);
    }
  }

  Future<ApiRepositoryResponse<DeviceGetKeyBundleResponse>> getKeyBundle(
      String deviceId) async {
    try {
      final response =
          await dioAuth.get('/device/key-bundle?deviceId=$deviceId');

      return ApiRepositoryResponse<DeviceGetKeyBundleResponse>(
        body: DeviceGetKeyBundleResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return parseError(e);
    }
  }

  Future<ApiRepositoryResponse<DeviceGetIdsResponse>> getIds(
    String userId,
  ) async {
    try {
      final response = await dioAuth.get('/device/ids?userId=$userId');

      return ApiRepositoryResponse<DeviceGetIdsResponse>(
        body: DeviceGetIdsResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return parseError(e);
    }
  }

  Future<ApiRepositoryResponse<DeviceGetPublicResponse>> getPublic(
      String deviceId) async {
    try {
      final response = await dioAuth.get('/device/public/$deviceId');

      return ApiRepositoryResponse<DeviceGetPublicResponse>(
        body: DeviceGetPublicResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return parseError(e);
    }
  }
}
