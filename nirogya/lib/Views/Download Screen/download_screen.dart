import 'package:flutter/material.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  String? selectedDataType;
  String? selectedFileType;
  DateTimeRange? selectedDateRange;
  bool isFileGenerated = false;

  final List<String> dataTypes = ['Stocks', 'Sales', 'Employee'];
  final List<String> fileTypes = ['PDF', 'Excel'];

  void _pickDateRangeDialog() async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                maxWidth: 600, maxHeight: 550), // Center dialog
            child: child,
          ),
        );
      },
    );
    if (pickedRange != null) {
      setState(() {
        selectedDateRange = pickedRange;
      });
    }
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

            // Dropdown for File Type
            const Text(
              'Select File Type',
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
              hint: const Text('Choose file type'),
              value: selectedFileType,
              onChanged: (value) {
                setState(() {
                  selectedFileType = value;
                });
              },
              items: fileTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Date Range Picker (as dialog)
            const Text(
              'Select Date Range',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: _pickDateRangeDialog,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
            const Spacer(),

            // Buttons in Column
            Column(
              children: [
                // Generate File Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isFileGenerated = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Generate File',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Download File Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isFileGenerated
                        ? () {
                            // Add download logic here
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFileGenerated ? Colors.green : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Download File',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
