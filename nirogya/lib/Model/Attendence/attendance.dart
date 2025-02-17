import 'package:hive/hive.dart';

part 'attendance.g.dart'; // Include the generated file

@HiveType(typeId: 9)
class Attendance {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  DateTime? timeIn;

  @HiveField(2)
  DateTime? timeOut;

  Attendance({
    required this.date,
    this.timeIn,
    this.timeOut,
  });

  bool get isAtWork => timeIn != null && timeOut == null;
}
