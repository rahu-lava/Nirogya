import 'package:hive/hive.dart';

import '../Final Medicine/final_medicine.dart';


part 'scanned_medicine.g.dart'; // This will be generated by Hive

@HiveType(typeId: 5) // Ensure this typeId is unique and not used by other models
class ScannedMedicine extends HiveObject {
  @HiveField(0)
  List<String> scannedBarcodes; // Array of scanned barcodes

  @HiveField(1)
  FinalMedicine finalMedicine; // Associated FinalMedicine object

  ScannedMedicine({
    required this.scannedBarcodes,
    required this.finalMedicine,
  });
}