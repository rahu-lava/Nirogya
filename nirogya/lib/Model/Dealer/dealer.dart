import 'package:hive/hive.dart';

part 'dealer.g.dart';

@HiveType(typeId: 1) // Unique typeId for this model
class Dealer extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String contactNumber;

  @HiveField(2)
  String gstin;

  @HiveField(3)
  bool hasWhatsApp;

  Dealer({
    required this.name,
    required this.contactNumber,
    required this.gstin,
    required this.hasWhatsApp,
  });
}
