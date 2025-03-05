import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:excel/excel.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../../Data/Added Medicine/added_medicine_repo.dart';
import '../../Data/Employee/employee_repo.dart';
import '../../Data/Final Medicine/final_medicine_repo.dart';
import '../../Data/Sales Bill/sales_bill_repo.dart';
import '../../Model/Attendence/attendance.dart';
import '../../Model/Bill/bill.dart';
import '../../Model/Employee/employee.dart';
import '../../Model/Final Medicine/final_medicine.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  String? selectedDataType;
  DateTimeRange? selectedDateRange;
  bool isFileGenerated = false;
  String? generatedFilePath;

  final List<String> dataTypes = ['Stocks', 'Sales', 'Employee'];

  void _pickDateRangeDialog() async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 550),
            child: child,
          ),
        );
      },
    );
    if (pickedRange != null) {
      setState(() {
        selectedDateRange = pickedRange;
        isFileGenerated = false; // Reset file generation state
      });
    }
  }

  Future<void> _generateAndOpenFile() async {
    if (selectedDataType == null ||
        (selectedDataType == 'Employee' && selectedDateRange == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all fields')),
      );
      return;
    }

    // Fetch data based on selectedDataType
    List<dynamic> data = [];
    switch (selectedDataType) {
      case 'Stocks':
        final addedMedicineRepo = AddedMedicineRepository();
        data = await addedMedicineRepo.getAllAddedMedicines();
        break;
      case 'Sales':
        data = await SalesBillRepository.getAllSalesBills();
        break;
      case 'Employee':
        data = await EmployeeRepository().getAllEmployees();
        break;
      default:
        break;
    }

    // Generate Excel file
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/${selectedDataType}_report.xlsx';
    await _generateExcel(data, filePath);

    setState(() {
      isFileGenerated = true;
      generatedFilePath = filePath;
    });

    // Open the generated file
    // await OpenFile.open(filePath);
    // ... inside _generateAndOpenFile after generating the file
    final result = await OpenFile.open(filePath);

// Check if no app is found to open the file
    if (result.type == ResultType.noAppToOpen) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'No app found to open Excel files. Please install Google Sheets.',
          ),
          action: SnackBarAction(
            label: 'Download',
            onPressed: () async {
              final Uri googleSheetsUrl = Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.google.android.apps.docs.editors.sheets');
              if (await canLaunchUrl(googleSheetsUrl)) {
                await launchUrl(googleSheetsUrl);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not launch the Play Store link.'),
                  ),
                );
              }
            },
          ),
        ),
      );
    }
  }

  Future<void> _generateExcel(List<dynamic> data, String filePath) async {
    final excel.Excel excelDoc = excel.Excel.createExcel();
    final excel.Sheet sheet = excelDoc['Sheet1'];

    if (selectedDataType == 'Sales') {
      // Generate Excel for Sales Bills
      sheet.appendRow([
        excel.TextCellValue('Invoice Number'),
        excel.TextCellValue('Date'),
        excel.TextCellValue('Customer Name'),
        excel.TextCellValue('Customer Contact'),
        excel.TextCellValue('Payment Method'),
        excel.TextCellValue('Total Amount'),
      ]);

      // Color headers yellow
      for (var i = 0; i < 6; i++) {
        sheet
            .cell(excel.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .cellStyle = excel.CellStyle(
          backgroundColorHex: excel.ExcelColor.fromInt(0xFFFFFF00), // Yellow
        );
      }

      for (var bill in data) {
        sheet.appendRow([
          excel.TextCellValue(bill.invoiceNumber),
          excel.TextCellValue(bill.date.toString()),
          excel.TextCellValue(bill.customerName),
          excel.TextCellValue(bill.customerContactNumber),
          excel.TextCellValue(bill.paymentMethod),
          excel.TextCellValue(bill.medicines
              .fold(0.0,
                  (sum, medicine) => sum + (medicine.price * medicine.quantity))
              .toStringAsFixed(2)),
        ]);
      }
    } else if (selectedDataType == 'Stocks') {
      // Generate Excel for Stocks
      sheet.appendRow([
        excel.TextCellValue('ID'),
        excel.TextCellValue('Product Name'),
        excel.TextCellValue('Price'),
        excel.TextCellValue('Quantity'),
        excel.TextCellValue('Expiry Date'),
        excel.TextCellValue('Batch'),
        excel.TextCellValue('Dealer Name'),
        excel.TextCellValue('GST'),
      ]);

      // Color headers yellow
      for (var i = 0; i < 8; i++) {
        sheet
            .cell(excel.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .cellStyle = excel.CellStyle(
          backgroundColorHex: excel.ExcelColor.fromInt(0xFFFFFF00), // Yellow
        );
      }

      for (var medicine in data) {
        sheet.appendRow([
          excel.TextCellValue(medicine.finalMedicine.id.toString()),
          excel.TextCellValue(medicine.finalMedicine.medicine.productName),
          excel.TextCellValue(medicine.finalMedicine.medicine.price.toString()),
          excel.TextCellValue(
              medicine.finalMedicine.medicine.quantity.toString()),
          excel.TextCellValue(
              medicine.finalMedicine.medicine.expiryDate.toString()),
          excel.TextCellValue(medicine.finalMedicine.medicine.batch),
          excel.TextCellValue(medicine.finalMedicine.medicine.dealerName),
          excel.TextCellValue(medicine.finalMedicine.medicine.gst.toString()),
        ]);
      }
    } else if (selectedDataType == 'Employee') {
      // Generate Excel for Employee Attendance
      final dates =
          _getDatesInRange(selectedDateRange!.start, selectedDateRange!.end);

      // Add headers (Employee Names)
      sheet.appendRow([
        excel.TextCellValue('Date'),
        ...data.map((employee) => excel.TextCellValue(employee.name)),
      ]);

      // Color headers yellow
      for (var i = 0; i < data.length + 1; i++) {
        sheet
            .cell(excel.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .cellStyle = excel.CellStyle(
          backgroundColorHex: excel.ExcelColor.fromInt(0xFFFFFF00), // Yellow
        );
      }

      // Add rows for each date
      for (var date in dates) {
        final row = <excel.CellValue?>[
          excel.TextCellValue(date.toString().split(' ')[0]),
        ];
        for (var employee in data) {
          // Find attendance record for the current date (compare only the date part)
          final attendanceList = employee.attendance.where((att) {
            final attendanceDate = DateTime(
              att.date.year,
              att.date.month,
              att.date.day,
            );
            final currentDate = DateTime(
              date.year,
              date.month,
              date.day,
            );
            return attendanceDate == currentDate;
          }).toList();

          final attendance =
              attendanceList.isEmpty ? null : attendanceList.first;

          // Check if both timeIn and timeOut are not null
          if (attendance != null &&
              attendance.timeIn != null &&
              attendance.timeOut != null) {
            row.add(excel.TextCellValue('Present'));
          } else {
            row.add(excel.TextCellValue('Absent'));
          }
        }
        sheet.appendRow(row);
      }
    }

    final file = File(filePath);
    await file.writeAsBytes(excelDoc.encode()!);
  }

  List<DateTime> _getDatesInRange(DateTime start, DateTime end) {
    final days = end.difference(start).inDays + 1; // Include the end date
    return List.generate(days, (i) => start.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for Data Type
            const Text(
              'Select Data Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
              ),
              hint: const Text('Choose data type'),
              value: selectedDataType,
              onChanged: (value) {
                setState(() {
                  selectedDataType = value;
                  isFileGenerated = false; // Reset file generation state
                });
              },
              items: dataTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Date Range Picker (as dialog) - Only for Employee
            if (selectedDataType == 'Employee')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Date Range',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: _pickDateRangeDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        selectedDateRange == null
                            ? 'Pick a date range'
                            : '${selectedDateRange!.start.toString().split(' ')[0]} - ${selectedDateRange!.end.toString().split(' ')[0]}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            const Spacer(),

            // Print/Open File Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generateAndOpenFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Print/Open File',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
