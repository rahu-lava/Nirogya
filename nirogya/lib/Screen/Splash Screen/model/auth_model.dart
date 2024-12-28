import 'package:isar/isar.dart';

part 'auth_model.g.dart';

@Collection()
class AuthModel {
  Id id = Isar.autoIncrement; // Automatically generates an ID

  @Index(unique: true)
  late String key; // Use a key like 'isLogged' for this example

  late bool value; // The value of the setting, e.g., true/false
}
