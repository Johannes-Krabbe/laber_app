import 'package:isar/isar.dart';

part 'contact.g.dart';

@collection
class Contact {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash)
  late String apiId;

  String? name;
  String? username;
  String? phoneNumber;
  String? profilePicture;
  String? status;

  List<String> deviceIds = [];
}
