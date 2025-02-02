import 'package:hive/hive.dart';
import '../Medicine/medicine.dart';

part 'bill.g.dart';

@HiveType(typeId: 3)
class Bill extends HiveObject {
  @HiveField(0)
  String invoiceNumber;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  List<Medicine> medicines;

  @HiveField(3)
  String dealerName;

  @HiveField(4)
  String dealerContact;

  @HiveField(5)
  String gstNumber;

  Bill({
    required this.invoiceNumber,
    required this.date,
    required this.medicines,
    required this.dealerName,
    required this.dealerContact,
    required this.gstNumber,
  });
}
