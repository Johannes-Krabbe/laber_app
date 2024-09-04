import 'package:isar/isar.dart';
import 'package:laber_app/store/types/contact.dart';
import 'package:laber_app/store/types/device.dart';
import 'package:laber_app/store/types/rawMessage.dart';

part 'chat.g.dart';

@collection
class Chat {
  Id id = Isar.autoIncrement;

  final messages = IsarLinks<RawMessage>();

  final devices = IsarLinks<Device>();

  @Backlink(to: 'chat')
  final contact = IsarLink<Contact>();
}
