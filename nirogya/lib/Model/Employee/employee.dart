  import 'package:hive/hive.dart';
  import '../Attendence/attendance.dart';

  part 'employee.g.dart'; // Include the generated file

  @HiveType(typeId: 8)
  class Employee {
    @HiveField(0)
    final String id;

    @HiveField(1)
    final String name;

    @HiveField(2)
    final String contact;

    @HiveField(3)
    final String profileImage;

    @HiveField(4)
    final DateTime dateOfJoining;

    @HiveField(5)
    List<Attendance> attendance;

    Employee({
      required this.id,
      required this.name,
      required this.contact,
      required this.profileImage,
      required this.dateOfJoining,
      List<Attendance>? attendance,
    }): attendance = attendance ?? [];
  }
