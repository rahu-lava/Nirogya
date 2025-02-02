import 'package:hive/hive.dart';
import '../Medicine/medicine.dart';


part 'final_medicine.g.dart';

@HiveType(typeId: 4) // Ensure this typeId is different from Medicine's typeId
class FinalMedicine extends HiveObject {
  @HiveField(0)
  String id; // Unique identifier

  @HiveField(2)
  Medicine medicine; // Composition of Medicine model

  FinalMedicine({
    required this.id,
    required this.medicine,
  });
}
