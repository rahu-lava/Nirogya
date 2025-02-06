import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nirogya/Model/Medicine/medicine.dart';
import 'package:nirogya/Model/Final Medicine/final_medicine.dart';
import 'package:nirogya/Data/Medicine/medicine_repository.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../Data/Added Medicine/added_medicine_repo.dart';
import '../../Data/Final Medicine History/final_medicine_history_repo.dart';
import '../../Data/Final Medicine/final_medicine_repo.dart';
import '../../Data/Medicine Queue/medicine_queue_repository.dart';
import '../../Widget/loading_widget.dart';

class MedicineQueueScreen extends StatefulWidget {
  @override
  _MedicineQueueScreenState createState() => _MedicineQueueScreenState();
}

class _MedicineQueueScreenState extends State<MedicineQueueScreen> {
  final MedicineQueueRepository _medicineQueueRepo = MedicineQueueRepository();
  final FinalMedicineRepository _finalMedicineRepo = FinalMedicineRepository();
  final AddedMedicineRepository _addedMedicineRepo = AddedMedicineRepository();
  final FinalMedicineHistoryRepository _finalMedicineHistoryRepo =
      FinalMedicineHistoryRepository();
  List<Medicine> _medicines = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _medicineQueueRepo.generateSampleMedicines(); // Generate sample data
    await _loadMedicines(); // Load medicines into the list
  }

  Future<void> _loadMedicines() async {
    final medicines = await _medicineQueueRepo.getAllMedicinesInQueue();
    setState(() {
      _medicines = medicines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Medicine Queue"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Medicine List (Scrollable)
                Expanded(
                  child: ListView.builder(
                    itemCount: _medicines.length,
                    itemBuilder: (context, index) {
                      final medicine = _medicines[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Medicine Name
                              Text(
                                medicine.productName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              // Details (Row with 2 Columns)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // First Column: Price and Quantity
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Price: \$${medicine.price}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Quantity: ${medicine.quantity}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20), // Space between columns
                                  // Second Column: Batch and Expiry
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Batch: ${medicine.batch}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Expiry: ${medicine.expiryDate}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 110), // Space below before sticky buttons
              ],
            ),
          ),
          // Sticky Buttons at the Bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Calculate total barcodes to be printed
                  int totalBarcodes = _medicines.fold(
                      0, (sum, medicine) => sum + medicine.quantity);

                  // Calculate total pages required (65 barcodes per page)
                  int totalPages = (totalBarcodes / 65).ceil();

                  // Show info box with printing tips
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Printing Tips:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "• Use A4 size paper for optimal results.",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "• Each page can hold up to 65 barcodes.",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "• Total barcodes to print: $totalBarcodes.",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "• Total pages required: $totalPages.",
                            style: TextStyle(fontSize: 14),
                          ),
                          if (totalBarcodes < 65)
                            Text(
                              "• Add more medicines to utilize the full page.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                              ),
                            ),
                        ],
                      ),
                      duration: Duration(seconds: 5),
                      action: SnackBarAction(
                        label: "Proceed",
                        onPressed: () async {
                          // Proceed with printing
                          _printBarcodes();
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Print Bar Code",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printBarcodes() async {
    // Show loading animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CommonLottieWidget(),
    );

    // Fetch medicines from the queue
    final medicines = await _medicineQueueRepo.getAllMedicinesInQueue();

    // Generate unique IDs and save to final medicine repository
    final List<Map<String, String>> barcodeData = [];
    for (var medicine in medicines) {
      // Generate a unique ID for this medicine (without the quantity part)
      final uniqueId = await UniqueIdGenerator.generateUniqueId(
          _finalMedicineRepo, _addedMedicineRepo);

      // Save the medicine to the FinalMedicine repository (without the quantity part)
      final finalMedicine = FinalMedicine(
        id: uniqueId,
        medicine: medicine,
      );
      final finalMedicine2 = FinalMedicine(
        id: uniqueId,
        medicine: medicine,
      );
      await _finalMedicineRepo.addFinalMedicine(finalMedicine);
      await _finalMedicineHistoryRepo.saveFinalMedicineHistory(finalMedicine2);

      // Truncate the medicine name to 15 characters if it exceeds the limit
      final truncatedName = medicine.productName.length > 15
          ? medicine.productName.substring(0, 15)
          : medicine.productName;

      // Add barcode data for PDF generation (one barcode per unit)
      for (var i = 1; i <= medicine.quantity; i++) {
        // Append the 3-digit quantity sequence to the unique ID
        final barcodeId = '$uniqueId${i.toString().padLeft(3, '0')}';
        barcodeData.add({
          "uniqueId": barcodeId, // Unique ID with quantity sequence
          "name": '$truncatedName$i', // Append quantity number to the name
          "batch": medicine.batch,
        });
      }
    }

    // Generate PDF with barcodes in a 13x5 grid layout
    final pdf = pw.Document();
    final barcodesPerPage = 13 * 5; // 13 rows x 5 columns
    final totalPages = (barcodeData.length / barcodesPerPage).ceil();

    for (var page = 0; page < totalPages; page++) {
      final startIndex = page * barcodesPerPage;
      final endIndex = (startIndex + barcodesPerPage) > barcodeData.length
          ? barcodeData.length
          : startIndex + barcodesPerPage;

      pdf.addPage(
        pw.Page(
          margin:
              const pw.EdgeInsets.all(20), // Consistent margin for all pages
          build: (pw.Context context) {
            return pw.GridView(
              crossAxisCount: 5, // 5 columns
              childAspectRatio: 0.5, // Consistent aspect ratio
              mainAxisSpacing: 15, // Consistent spacing
              crossAxisSpacing: 15, // Consistent spacing
              children: List.generate(
                endIndex - startIndex,
                (index) {
                  final data = barcodeData[startIndex + index];
                  return pw.Container(
                    margin: pw.EdgeInsets.all(2), // Minimal padding
                    child: pw.Column(
                      children: [
                        // Barcode
                        pw.BarcodeWidget(
                          data: data["uniqueId"]!,
                          drawText: false,
                          barcode: pw.Barcode.code128(),
                          width: 80, // Barcode width
                          height: 25, // Barcode height
                        ),
                        pw.Text(
                          data["name"]!, // Truncated name with quantity number
                          style: pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    }

    // Print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    // Clear the medicine queue
    await _medicineQueueRepo.clearQueue();

    // Hide loading animation
    Navigator.of(context).pop();

    // Refresh the list
    await _loadMedicines();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Barcodes printed and queue cleared.")),
    );
  }
}

class UniqueIdGenerator {
  static const String _chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  static final Random _random = Random();

  // Generate a random alphanumeric string of length 4
  static String _generateRandomAlphanumeric() {
    return String.fromCharCodes(
      Iterable.generate(
        4,
        (_) => _chars.codeUnitAt(_random.nextInt(_chars.length)),
      ),
    );
  }

  // Generate a unique ID in the format N + 4 alphanumeric characters
  static Future<String> generateUniqueId(
    FinalMedicineRepository finalMedicineRepo,
    AddedMedicineRepository addedMedicineRepo, // Added Medicine repository
  ) async {
    String uniqueId;
    bool idExists;

    do {
      // Generate a new ID (without the quantity part)
      uniqueId = 'N${_generateRandomAlphanumeric()}';

      // Check if the ID already exists in FinalMedicine
      final finalMedicine =
          await finalMedicineRepo.getFinalMedicineById(uniqueId);
      bool idExistsInFinalMedicine = finalMedicine != null;

      // Check if the ID already exists in AddedMedicine
      final addedMedicines = await addedMedicineRepo.getAllAddedMedicines();
      bool idExistsInAddedMedicine = addedMedicines.any(
        (medicine) => medicine.finalMedicine.id == uniqueId,
      );

      // If the ID exists in either repository, regenerate
      idExists = idExistsInFinalMedicine || idExistsInAddedMedicine;
    } while (idExists); // Regenerate if the ID already exists

    return uniqueId;
  }
}
