import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Model/Attendence/attendance.dart';
import '../../Model/Employee/employee.dart';

class EmployeeRepository {
  late Box<Employee> _employeeBox;
  bool _isBoxOpen = false;

  // Initialize the repository and open the box
  EmployeeRepository() {
    _init();
  }

  // Initialize Hive and open the box
  Future<void> _init() async {
    if (!_isBoxOpen) {
      _employeeBox = await Hive.openBox<Employee>('employees');
      _isBoxOpen = true;
    }
  }

  // Ensure the box is open before performing any operation
  Future<void> _ensureBoxIsOpen() async {
    if (!_isBoxOpen || !_employeeBox.isOpen) {
      await _init(); // Reopen the box if it's closed
    }
  }

  // Close the box when the repository is disposed
  Future<void> close() async {
    if (_isBoxOpen && _employeeBox.isOpen) {
      await _employeeBox.close();
      _isBoxOpen = false;
    }
  }

  // Add a new employee
  Future<void> addEmployee(Employee employee) async {
    await _ensureBoxIsOpen(); // Ensure the box is open
    await _employeeBox.add(employee);
  }

  // Get all employees
  Future<List<Employee>> getAllEmployees() async {
    await _ensureBoxIsOpen(); // Ensure the box is open
    return _employeeBox.values.toList();
  }

  // Get an employee by ID
  Future<Employee?> getEmployeeById(String id) async {
    await _ensureBoxIsOpen(); // Ensure the box is open
    try {
      return _employeeBox.values.firstWhere((emp) => emp.id == id);
    } catch (e) {
      // Handle the error (e.g., box is closed)
      await _ensureBoxIsOpen(); // Reopen the box if it's closed
      return _employeeBox.values.firstWhere((emp) => emp.id == id);
    }
  }

  // Update an employee
  Future<void> updateEmployee(Employee employee) async {
    await _ensureBoxIsOpen(); // Ensure the box is open
    final index =
        _employeeBox.values.toList().indexWhere((emp) => emp.id == employee.id);
    if (index != -1) {
      await _employeeBox.putAt(index, employee);
    }
  }

  // Delete an employee
  Future<void> deleteEmployee(String id) async {
    await _ensureBoxIsOpen(); // Ensure the box is open
    final index =
        _employeeBox.values.toList().indexWhere((emp) => emp.id == id);
    if (index != -1) {
      await _employeeBox.deleteAt(index);
    }
  }

  // Mark attendance for an employee
  Future<void> markAttendance(BuildContext context,
      String employeeId, DateTime timeIn, DateTime? timeOut) async {
    await _ensureBoxIsOpen(); // Ensure the box is open
    final employee = await getEmployeeById(employeeId);
    if (employee != null) {
      // Find today's attendance record
      final today = DateTime.now();
      final existingAttendance = employee.attendance.firstWhere(
        (att) =>
            att.date.day == today.day &&
            att.date.month == today.month &&
            att.date.year == today.year,
        orElse: () => Attendance(date: today), // Default if no record exists
      );

      // If the record already exists, update it
      if (existingAttendance.timeIn != null) {
        if (timeOut != null) {
          // Update timeOut if the employee is clocking out
          existingAttendance.timeOut = timeOut;
        } else {
ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Attendance already recorded for today!'),
                backgroundColor: Colors.red,
              ),
            );
        }
      } else {
        // If no record exists, create a new one
        existingAttendance.timeIn = timeIn;
        existingAttendance.timeOut = timeOut;
        employee.attendance.add(existingAttendance);
      }

      // Save the updated employee record
      await updateEmployee(employee);
    }
  }

  // Check if an employee is currently at work
  Future<bool> isEmployeeAtWork(String employeeId) async {
    await _ensureBoxIsOpen(); // Ensure the box is open
    final employee = await getEmployeeById(employeeId);
    if (employee != null) {
      final todayAttendance = employee.attendance.firstWhere(
        (att) =>
            att.date.day == DateTime.now().day &&
            att.date.month == DateTime.now().month &&
            att.date.year == DateTime.now().year,
        orElse: () => Attendance(date: DateTime.now()),
      );
      return todayAttendance.isAtWork; // Use the isAtWork getter
    }
    return false;
  }

  // Get attendance records for an employee
  Future<List<Attendance>> getAttendanceRecords(String employeeId) async {
    await _ensureBoxIsOpen(); // Ensure the box is open
    final employee = await getEmployeeById(employeeId);
    if (employee != null) {
      return employee.attendance;
    }
    return [];
  }
}
