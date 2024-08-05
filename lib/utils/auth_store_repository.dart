import 'package:laber_app/types/client_me_device.dart';
import 'package:laber_app/types/client_me_user.dart';

class AuthStateStore {
  final String token;
  final ClientMeUser meUser;
  final ClientMeDevice meDevice;

  AuthStateStore(this.token, this.meUser, this.meDevice);
}
