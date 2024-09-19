import 'package:laber_app/api/repositories/device_repository.dart';
import 'package:laber_app/services/key_agreement_service.dart';
import 'package:laber_app/store/secure/self_device_store_service.dart';
import 'package:laber_app/utils/curve/crypto_util.dart';

class SelfDevicesService {
  // This function fetches the list of devices that belog to the self user, checks if there are any devices that dont have a shared device secret with the meDevice and initiates a key agreement with them
  static initiateKeyAgreement() async {
    // Fetch me
    final selfDevicesRes = await DeviceRepository().getAll();

    if (selfDevicesRes.status == 200 && selfDevicesRes.body?.devices != null) {
      // Iterate over the self devices
      for (var device in selfDevicesRes.body!.devices!) {
        // If its already stored, skip (stored devices always have a shared secret with meDevice)
        if (await SelfDeviceStoreService.get(device.id!) != null) {
          continue;
        }

        // Initiate key agreement, sends out message
        final result =
            await KeyAgreementService.creteInitializationMessage(device.id!);

        if (result == null) {
          // TODO handle error
          continue;
        }

        // Store the shared secret
        await SelfDeviceStoreService.store(
          SelfDeviceStore(
            secret: await CryptoUtil.secretKeyToString(result.sharedSecret),
            apiId: device.id!,
          ),
        );
      }
    } else {
      // TODO handle error
    }
  }

  static notifyChatCreation(String contactApiId) async {
    await initiateKeyAgreement();

    // TODO notify chat creation
  }
}
