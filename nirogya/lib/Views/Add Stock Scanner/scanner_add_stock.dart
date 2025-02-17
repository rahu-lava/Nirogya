import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:nirogya/Model/Scanned%20Medicine/scanned_medicine.dart';
import 'package:nirogya/Utils/testing_utils.dart';
import 'package:nirogya/Views/Added%20Product%20Screen/added_product_list.dart';
import 'package:nirogya/Data/Scanned%20Medicine/scanned_medicine_repo.dart';
import 'package:nirogya/Data/Added%20Medicine/added_medicine_repo.dart';
import 'package:nirogya/Views/Home/home.dart';

import '../../Model/Final Medicine/final_medicine.dart';
import '../../Model/Medicine/medicine.dart'; // New repository

class ScannerAddStock extends StatefulWidget {
  @override
  _ScannerAddStockState createState() => _ScannerAddStockState();
}

class _ScannerAddStockState extends State<ScannerAddStock> {
  List<Map<String, dynamic>> scannedItems = [];
  bool isFlashOn = false;
  MobileScannerController _scanController = MobileScannerController();
  final ScannedMedicineRepository _scannedMedicineRepo =
      ScannedMedicineRepository();
  final AddedMedicineRepository _addedMedicineRepo = AddedMedicineRepository();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Temporary list to store scanned barcodes (keyed by base ID)
  Map<String, List<String>> _tempScannedBarcodes = {};

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Handle barcode scanning
  void _onBarcodeScanned(String barcode) async {
    if (barcode.startsWith('N')) {
      try {
        // Extract the base ID (first 5 characters)
        final String baseId = barcode.substring(0, 5);

        // Fetch all scanned medicines
        final scannedMedicines =
            await _scannedMedicineRepo.getAllScannedMedicines();

        // Find the medicine with the matching base ID
        final medicine = scannedMedicines.firstWhere(
          (med) => med.finalMedicine.id.startsWith(baseId),
          orElse: () => ScannedMedicine(
            scannedBarcodes: [],
            finalMedicine: FinalMedicine(
              id: '',
              medicine: Medicine(
                productName: '',
                price: 0.0,
                quantity: 0,
                expiryDate: '',
                batch: '',
                dealerName: '',
                gst: 0,
                companyName: '',
                alertQuantity: 0,
                description: '',
                imagePath: '',
              ),
            ),
          ),
        );

        // If the medicine is found and the barcode is in the list
        if (medicine.finalMedicine.id.isNotEmpty &&
            medicine.scannedBarcodes.contains(barcode)) {
          // Check if the barcode is already scanned in the temporary list
          if (_tempScannedBarcodes.containsKey(baseId) &&
              _tempScannedBarcodes[baseId]!.contains(barcode)) {
            // Do not proceed if the barcode is already scanned
            return;
          }

          // Add the scanned barcode to the temporary list
          if (!_tempScannedBarcodes.containsKey(baseId)) {
            _tempScannedBarcodes[baseId] = [];
          }
          _tempScannedBarcodes[baseId]!.add(barcode);

          // Play a sound to indicate successful scan
          await _audioPlayer.play(AssetSource('sound/scan-success.mp3'));

// Update the UI
          setState(() {
            scannedItems = scannedMedicines.where((medicine) {
              final baseId = medicine.finalMedicine.id.substring(0, 5);
              return (_tempScannedBarcodes[baseId]?.length ?? 0) > 0;
            }).map((medicine) {
              final baseId = medicine.finalMedicine.id.substring(0, 5);
              return {
                'id': medicine.finalMedicine.id,
                'name': medicine.finalMedicine.medicine.productName,
                'quantity': _tempScannedBarcodes[baseId]?.length ??
                    0, // Show scanned quantity
                'scannedBarcodes':
                    _tempScannedBarcodes[baseId] ?? [], // Show scanned barcodes
              };
            }).toList();
          });
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Barcode not found or already scanned')),
          // );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid barcode: Must start with "N"')),
      );
    }
  }

  int get totalQuantity =>
      scannedItems.fold(0, (sum, item) => sum + (item['quantity'] ?? 0) as int);

  void _removeItem(int index) {
    setState(() {
      scannedItems.removeAt(index);
    });
  }

  // Transfer medicines from Scanned to Added and clear Scanned
  Future<void> _transferAndClear() async {
    final scannedMedicines =
        await _scannedMedicineRepo.getAllScannedMedicines();

    for (var medicine in scannedMedicines) {
      final String baseId = medicine.finalMedicine.id.substring(0, 5);

      if (_tempScannedBarcodes.containsKey(baseId)) {
        // Remove the scanned barcodes from the original list
        medicine.scannedBarcodes.removeWhere(
            (barcode) => _tempScannedBarcodes[baseId]!.contains(barcode));
        await TestingUtils.printAllAddedMedicines();
        print("before");
        // Decrease the quantity by the number of scanned barcodes
        ScannedMedicine scannedMedicine = ScannedMedicine(
          scannedBarcodes: medicine.scannedBarcodes,
          finalMedicine: FinalMedicine(
            id: medicine.finalMedicine.id,
            medicine: Medicine(
              productName: medicine.finalMedicine.medicine.productName,
              price: medicine.finalMedicine.medicine.price,
              quantity: medicine.finalMedicine.medicine.quantity -
                  _tempScannedBarcodes[baseId]!.length,
              expiryDate: medicine.finalMedicine.medicine.expiryDate,
              batch: medicine.finalMedicine.medicine.batch,
              dealerName: medicine.finalMedicine.medicine.productName,
              gst: medicine.finalMedicine.medicine.gst,
              companyName: medicine.finalMedicine.medicine.companyName,
              alertQuantity: medicine.finalMedicine.medicine.alertQuantity,
              description: medicine.finalMedicine.medicine.description,
              imagePath: medicine.finalMedicine.medicine.imagePath,
            ),
          ),
        );
        // scannedMedicine.finalMedicine.medicine.quantity -=
        //     _tempScannedBarcodes[baseId]!.length;
        print("After");
        await TestingUtils.printAllAddedMedicines();

        await _scannedMedicineRepo.updateScannedMedicine(scannedMedicine);

        // Check if the medicine already exists in Added Medicine
        final addedMedicines = await _addedMedicineRepo.getAllAddedMedicines();
        await TestingUtils.printAllAddedMedicines();
        final existingAddedMedicine = addedMedicines.firstWhere(
          (med) => med.finalMedicine.id.startsWith(baseId),
          orElse: () => ScannedMedicine(
            scannedBarcodes: [],
            finalMedicine: FinalMedicine(
              id: '',
              medicine: Medicine(
                productName: '',
                price: 0.0,
                quantity: 0,
                expiryDate: '',
                batch: '',
                dealerName: '',
                gst: 0,
                companyName: '',
                alertQuantity: 0,
                description: '',
                imagePath: '',
              ),
            ),
          ),
        );

        if (existingAddedMedicine.finalMedicine.id.isNotEmpty) {
          // If the medicine already exists, append the barcodes and increase the quantity
          print("Updating the current data......");
          print("=====");
          print("=====");
          print("=====");
          print("=====");
          print(existingAddedMedicine.finalMedicine.medicine.quantity);
          print("=====");
          print("=====");
          print("=====");
          print("=====");
          existingAddedMedicine.scannedBarcodes
              .addAll(_tempScannedBarcodes[baseId]!);
          existingAddedMedicine.finalMedicine.medicine.quantity +=
              _tempScannedBarcodes[baseId]!.length;
          print("=====");
          print("=====");
          print("=====");
          print(_tempScannedBarcodes[baseId]!.length);
          print("=====");
          print(existingAddedMedicine.finalMedicine.medicine.quantity);
          print("=====");
          print("=====");
          print("=====");
          print("=====");
          await _addedMedicineRepo.updateAddedMedicine(existingAddedMedicine);
        } else {
          // If the medicine does not exist, create a new entry
          // ScannedMedicine _scannedMed = ScannedMedicine(
          //   scannedBarcodes: _tempScannedBarcodes[baseId]!,
          //   finalMedicine: medicine.finalMedicine,
          // );
          ScannedMedicine _scannedMed = ScannedMedicine(
            scannedBarcodes: _tempScannedBarcodes[baseId]!,
            finalMedicine: FinalMedicine(
              id: medicine.finalMedicine.id,
              medicine: Medicine(
                productName: medicine.finalMedicine.medicine.productName,
                price: medicine.finalMedicine.medicine.price,
                quantity: _tempScannedBarcodes[baseId]!.length,
                expiryDate: medicine.finalMedicine.medicine.expiryDate,
                batch: medicine.finalMedicine.medicine.batch,
                dealerName: medicine.finalMedicine.medicine.productName,
                gst: medicine.finalMedicine.medicine.gst,
                companyName: medicine.finalMedicine.medicine.companyName,
                alertQuantity: medicine.finalMedicine.medicine.alertQuantity,
                description: medicine.finalMedicine.medicine.description,
                imagePath: medicine.finalMedicine.medicine.imagePath,
              ),
            ),
          );
          _scannedMed.finalMedicine.medicine.quantity =
              _tempScannedBarcodes[baseId]!.length;
          await _addedMedicineRepo.addAddedMedicine(_scannedMed);
        }
      }
    }

    // Clear the temporary list
    _tempScannedBarcodes.clear();

    // Navigate to the ProductList screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(initialIndex: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner Add Stock'),
        actions: [
          IconButton(
            icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                isFlashOn = !isFlashOn;
                _scanController.toggleTorch();
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scanController,
            onDetect: (barcode) {
              if (barcode.barcodes.isNotEmpty &&
                  barcode.barcodes.first.rawValue != null) {
                _onBarcodeScanned(barcode.barcodes.first.rawValue!);
              }
            },
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: scannedItems.length,
                        itemBuilder: (context, index) {
                          final item = scannedItems[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: ExpansionTile(
                              leading:
                                  Icon(Icons.medication, color: Colors.blue),
                              title: Text(
                                item['name'] ?? 'Unknown',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('Quantity: ${item['quantity']}'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeItem(index),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: (item['scannedBarcodes'] as List)
                                        .map<Widget>(
                                          (barcode) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              barcode,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Quantity: $totalQuantity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _transferAndClear,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Done'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
