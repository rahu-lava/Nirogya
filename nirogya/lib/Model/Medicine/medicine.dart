import 'package:hive/hive.dart';

part 'medicine.g.dart';

@HiveType(typeId: 1)
class Medicine extends HiveObject {
  @HiveField(0)
  String productName;

  @HiveField(1)
  double price;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  String expiryDate;

  @HiveField(4)
  String batch;

  @HiveField(5)
  String? dealerName;

  @HiveField(6)
  String? companyName;

  @HiveField(7)
  int? alertQuantity;

  @HiveField(8)
  String? description;

  @HiveField(9)
  String? imagePath;

  Medicine({
    required this.productName,
    required this.price,
    required this.quantity,
    required this.expiryDate,
    required this.batch,
    this.dealerName,
    this.companyName,
    this.alertQuantity,
    this.description,
    this.imagePath,
  });
}
