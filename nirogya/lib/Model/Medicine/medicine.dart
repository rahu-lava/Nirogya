  import 'package:hive/hive.dart';

  part 'medicine.g.dart';

  @HiveType(typeId: 0)
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
    String dealerName;

    @HiveField(6)
    int gst;

    @HiveField(7)
    String? companyName;

    @HiveField(8)
    int? alertQuantity;

    @HiveField(9)
    String? description;

    @HiveField(10)
    String? imagePath;

    Medicine({
      required this.productName,
      required this.price,
      required this.quantity,
      required this.expiryDate,
      required this.batch,
      required this.dealerName,
      required this.gst,
      this.companyName,
      this.alertQuantity,
      this.description,
      this.imagePath,
    });
  }
