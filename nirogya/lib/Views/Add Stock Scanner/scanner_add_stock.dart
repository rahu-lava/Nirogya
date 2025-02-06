import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:nirogya/Model/Scanned%20Medicine/scanned_medicine.dart';
import 'package:nirogya/Views/Added%20Product%20Screen/added_product_list.dart';
import 'package:nirogya/Data/Scanned%20Medicine/scanned_medicine_repo.dart';
import 'package:nirogya/Data/Added%20Medicine/added_medicine_repo.dart'; // New repository

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
  final AddedMedicineRepository _addedMedicineRepo =
      AddedMedicineRepository(); // New repository
  final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  // Handle barcode scanning
  void _onBarcodeScanned(String barcode) async {
    if (barcode.startsWith('N')) {
      try {
        bool isValid =
            await _scannedMedicineRepo.addScannedMedicine(barcode, context);

        if (isValid) {
          // Play a sound
          await _audioPlayer.play(AssetSource('sound/scan-success.mp3'));

          // Fetch the updated list of scanned medicines
          final scannedMedicine =
              await _scannedMedicineRepo.getAllScannedMedicines();
          setState(() {
            scannedItems.clear(); // Clear the previous list
            scannedItems.addAll(scannedMedicine.map((medicine) {
              return {
                'id': medicine.finalMedicine.id,
                'name': medicine.finalMedicine.medicine.productName,
                'quantity': medicine.finalMedicine.medicine.quantity,
                'scannedBarcodes': medicine.scannedBarcodes,
              };
            }).toList());
          });
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
    // Transfer all scanned medicines to Added Medicine
    final scannedMedicines =
        await _scannedMedicineRepo.getAllScannedMedicines();
    for (var medicine in scannedMedicines) {
      ScannedMedicine _scannedMed = ScannedMedicine(
          scannedBarcodes: medicine.scannedBarcodes,
          finalMedicine: medicine.finalMedicine);
      await _addedMedicineRepo.addAddedMedicine(_scannedMed);
    }

    // Clear the Scanned Medicine list
    await _scannedMedicineRepo.clearAllScannedMedicines();

    // Navigate to the ProductList screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ProductList(),
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
                              leading: Icon(Icons.medication,
                                  color: Colors.blue), // Medicine icon
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
                      onPressed: _transferAndClear, // Transfer and clear
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
