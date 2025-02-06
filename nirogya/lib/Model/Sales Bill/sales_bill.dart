import 'package:hive/hive.dart';
import '../Medicine/medicine.dart';

part 'sales_bill.g.dart';

@HiveType(typeId: 7) // Change the typeId to a unique number
class SalesBill extends HiveObject {
  @HiveField(0)
  String invoiceNumber;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  List<Medicine> medicines;

  @HiveField(3)
  String customerName;

  @HiveField(4)
  String customerContactNumber;

  @HiveField(5)
  String paymentMethod;

  SalesBill({
    required this.invoiceNumber,
    required this.date,
    required this.medicines,
    required this.customerName,
    required this.customerContactNumber,
    required this.paymentMethod,
  });
}
