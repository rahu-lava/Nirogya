import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 2) // Unique typeId for the model
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String contact;

  @HiveField(2)
  String shopName;

  @HiveField(3)
  String address;

  @HiveField(4)
  String gstin;

  @HiveField(5)
  String? profileImagePath;

  User({
    required this.name,
    required this.contact,
    required this.shopName,
    required this.address,
    required this.gstin,
    this.profileImagePath,
  });
}
