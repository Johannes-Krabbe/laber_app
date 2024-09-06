import 'package:laber_app/api/api_provider.dart';
import 'package:laber_app/api/models/responses/message/get_new.dart';
import 'package:laber_app/api/models/responses/message/post_new.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';

class MessageRepository extends ApiProvider {
  Future<ApiRepositoryResponse<MessageGetNewResponse>> getNew() async {
    try {
      final authStateStore =
          await AuthStateStoreService.readFromSecureStorage();
      if (authStateStore == null) {
        return ApiRepositoryResponse<MessageGetNewResponse>(
          status: 500,
        );
      }
      final response =
          await dioAuth.get('/message/new/${authStateStore.meDevice.id}');

      return ApiRepositoryResponse<MessageGetNewResponse>(
        body: MessageGetNewResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return ApiRepositoryResponse<MessageGetNewResponse>(
        status: 500,
      );
    }
  }

  Future<ApiRepositoryResponse<MessagePostNewResponse>> postNew(
      String content, String recipientDeviceId) async {
    try {
      final authStateStore =
          await AuthStateStoreService.readFromSecureStorage();
      if (authStateStore == null) {
        return ApiRepositoryResponse<MessagePostNewResponse>(
          status: 500,
        );
      }

      final response = await dioAuth.post('/message/new', data: {
        'content': content,
        'recipientDeviceId': recipientDeviceId,
        'senderDeviceId': authStateStore.meDevice.id
      });

      return ApiRepositoryResponse<MessagePostNewResponse>(
        body: MessagePostNewResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return ApiRepositoryResponse<MessagePostNewResponse>(
        status: 500,
      );
    }
  }
}
