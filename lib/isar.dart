import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:laber_app/store/types/chat.dart';
import 'package:laber_app/store/types/contact.dart';
import 'package:laber_app/store/types/device.dart';
import 'package:laber_app/store/types/raw_message.dart';

const instanceName = 'default';

Future<Isar> getIsar() async {
  Isar? instance = Isar.getInstance(instanceName);

  if (instance != null) {
    return instance;
  }
  final dir = await getApplicationDocumentsDirectory();

  instance = await Isar.open(
    [ContactSchema, DeviceSchema, ChatSchema, RawMessageSchema],
    directory: dir.path,
    name: instanceName
  );

  return instance;
}
