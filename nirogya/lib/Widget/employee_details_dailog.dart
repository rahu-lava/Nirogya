import 'dart:io';

import 'package:flutter/material.dart';
import '../../Model/Employee/employee.dart';

class EmployeeDetailsDialog extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailsDialog({super.key, required this.employee});

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
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 10),

          // Date of Joining
          Text(
            "Date of Joining: ${employee.dateOfJoining.toLocal()}",
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
                  title: Text("Date: ${attendance.date.toLocal()}"),
                  subtitle: Text(
                    "Time In: ${attendance.timeIn?.toLocal() ?? 'N/A'}\n"
                    "Time Out: ${attendance.timeOut?.toLocal() ?? 'N/A'}",
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}