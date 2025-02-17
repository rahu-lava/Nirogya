import 'package:flutter/material.dart';
import 'package:nirogya/Data/Employee/employee_repo.dart';
import 'package:nirogya/Model/Employee/employee.dart';
import 'package:nirogya/Views/Add%20Employee/add_employee.dart';
import 'package:nirogya/Widget/bills_card.dart';

import '../../Model/Attendence/attendance.dart';
import '../../Widget/employee_details_dailog.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final EmployeeRepository _employeeRepository = EmployeeRepository();
  List<Employee> employees = [];
  List<Employee> employeesAtWork = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    employees = await _employeeRepository.getAllEmployees();
    employeesAtWork = await _getEmployeesAtWork();
    setState(() {}); // Trigger UI rebuild
  }

  Future<List<Employee>> _getEmployeesAtWork() async {
    final List<Employee> atWork = [];
    for (final employee in employees) {
      if (await _employeeRepository.isEmployeeAtWork(employee.id)) {
        atWork.add(employee);
      }
    }
    return atWork;
  }

  // Common widget for list items
  Widget staffListItem(Employee employee) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.grey.shade200,
        title: Text(
          employee.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          "Contact: ${employee.contact}",
          style: const TextStyle(fontSize: 14),
        ),
        trailing: employeesAtWork.contains(employee)
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.cancel, color: Colors.red),
        onTap: () {
          // Open the bottom dialog with employee details
          _showEmployeeDetailsDialog(employee);
        },
      ),
    );
  }

  void _showEmployeeDetailsDialog(Employee employee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allow the dialog to take up most of the screen
      builder: (context) {
        return EmployeeDetailsDialog(employee: employee);
      },
    );
  }

  // Function to show Clock In dialog
  void showClockInDialog() {
    final employeesNotAtWork =
        employees.where((emp) => !employeesAtWork.contains(emp)).toList();

    showDialog(
      context: context,
      builder: (context) {
        String? selectedEmployeeId;
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Clock In",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Select Employee",
                    border: OutlineInputBorder(),
                  ),
                  items: employeesNotAtWork
                      .map((emp) => DropdownMenuItem(
                            value: emp.id,
                            child: Text(emp.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedEmployeeId = value;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Time In", style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 5),
                        Text(
                          "${DateTime.now().hour}:${DateTime.now().minute}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedEmployeeId != null) {
                      await _employeeRepository.markAttendance(
                        selectedEmployeeId!,
                        DateTime.now(),
                        null, // Time out is null for clock-in
                      );
                      await _loadEmployees(); // Refresh the list
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Mark"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to show Clock Out dialog
  void showClockOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedEmployeeId;
        String timeInDisplay = "-"; // Default value for Time In
        DateTime? timeIn; // Store the actual clock-in time

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Clock Out",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Employee",
                        border: OutlineInputBorder(),
                      ),
                      items: employeesAtWork
                          .map((emp) => DropdownMenuItem(
                                value: emp.id,
                                child: Text(emp.name),
                              ))
                          .toList(),
                      onChanged: (value) async {
                        if (value != null) {
                          final employee =
                              await _employeeRepository.getEmployeeById(value);
                          if (employee != null) {
                            // Find today's attendance record
                            final todayAttendance =
                                employee.attendance.firstWhere(
                              (att) =>
                                  att.date.day == DateTime.now().day &&
                                  att.date.month == DateTime.now().month &&
                                  att.date.year == DateTime.now().year,
                              orElse: () => Attendance(date: DateTime.now()),
                            );

                            // Update the Time In display
                            setState(() {
                              selectedEmployeeId = value;
                              timeIn = todayAttendance.timeIn;
                              timeInDisplay =
                                  "${timeIn!.hour}:${timeIn!.minute} ${timeIn!.day}/${timeIn!.month}/${timeIn!.year}";
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Time In",
                                style: TextStyle(fontSize: 14)),
                            const SizedBox(height: 5),
                            Text(
                              timeInDisplay, // Display the clock-in time or "-"
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward, size: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Time Out",
                                style: TextStyle(fontSize: 14)),
                            const SizedBox(height: 5),
                            Text(
                              "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedEmployeeId != null && timeIn != null) {
                          await _employeeRepository.markAttendance(
                            selectedEmployeeId!,
                            timeIn!, // Use the stored clock-in time
                            DateTime.now(), // Current time for clock-out
                          );

                          // Refresh the employee list and update the UI
                          await _loadEmployees();

                          // Close the dialog
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Mark"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AddEmployeeScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff920000),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Add New Employee",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BillsCard(title: "Staff Count", amount: "${employees.length}"),
                BillsCard(
                    title: "At Work", amount: "${employeesAtWork.length}"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: showClockInDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff920000),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      "Clock In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: showClockOutDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff920000),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      "Clock Out",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: const Color(0xff920000),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 4,
                      labelColor: const Color.fromARGB(255, 128, 0, 0),
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      tabs: const [
                        Tab(text: "All Staff"),
                        Tab(text: "Staff On Work"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ListView(
                            children: employees
                                .map((emp) => staffListItem(emp))
                                .toList(),
                          ),
                          ListView(
                            children: employeesAtWork
                                .map((emp) => staffListItem(emp))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
