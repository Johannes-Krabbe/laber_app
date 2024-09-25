import 'package:laber_app/api/api_errors.dart';
import 'package:laber_app/api/api_provider.dart';
import 'package:laber_app/api/models/responses/message/get_new.dart';
import 'package:laber_app/api/models/responses/message/post_new.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';
import 'package:laber_app/store/types/outgoing_message.dart';

class ApiMessageRepository extends ApiProvider {
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
      return parseError(e);
      
    }
  }

  Future<ApiRepositoryResponse<MessagePostNewResponse>> postNew(
      OutgoingMessage message) async {
    try {
      final authStateStore =
          await AuthStateStoreService.readFromSecureStorage();

      if (authStateStore == null) {
        throw Exception('AuthStateStore is null');
      }

      final response = await dioAuth.post('/message/new', data: {
        'content': message.content,
        'recipientDeviceId': message.recipientDeviceId,
        'senderDeviceId': authStateStore.meDevice.id,
      });

      return ApiRepositoryResponse<MessagePostNewResponse>(
        body: MessagePostNewResponse.fromJson(response.data),
        status: response.statusCode!,
      );
    } catch (e) {
      return parseError(e);
    }
  }
}
