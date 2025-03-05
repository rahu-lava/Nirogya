import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import this
import '../../Model/Employee/employee.dart';

class EmployeeDetailsDialog extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailsDialog({super.key, required this.employee});

  String formatTime(DateTime? dateTime) {
    return dateTime != null ? DateFormat('HH:mm').format(dateTime) : 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Employee Name
          Text(
            employee.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Contact
          Text(
            "Contact: ${employee.contact}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),

          // Profile Image
          if (employee.profileImage.isNotEmpty)
            Image.file(
              File(employee.profileImage),
              height: 250,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          const SizedBox(height: 10),

          // Date of Joining
          Text(
            "Date of Joining: ${DateFormat('yyyy-MM-dd').format(employee.dateOfJoining)}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // Attendance Records
          const Text(
            "Attendance Records:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (employee.attendance.isEmpty)
            const Text("No attendance records found."),
          if (employee.attendance.isNotEmpty)
            Column(
              children: employee.attendance.map((attendance) {
                return ListTile(
                  title: Text(
                      "Date: ${DateFormat('yyyy-MM-dd').format(attendance.date)}"),
                  subtitle: Text(
                    "Time In: ${formatTime(attendance.timeIn)}\n"
                    "Time Out: ${formatTime(attendance.timeOut)}",
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
