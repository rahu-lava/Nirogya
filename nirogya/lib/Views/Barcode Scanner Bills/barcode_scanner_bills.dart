import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nirogya/Data/Added Medicine/added_medicine_repo.dart'; // Import the Added Medicine repository
import 'package:nirogya/Model/Scanned Medicine/scanned_medicine.dart'; // Import the ScannedMedicine model
import '../../Model/Final Medicine/final_medicine.dart';
import '../../Model/Medicine/medicine.dart';
import '../CustomerDetails/customer_details.dart';

class BarcodeScannerWithList extends StatefulWidget {
  @override
  _BarcodeScannerWithListState createState() => _BarcodeScannerWithListState();
}

class _BarcodeScannerWithListState extends State<BarcodeScannerWithList> {
  List<Map<String, dynamic>> scannedItems = [];
  List<String> scannedBarcodes = [];
  bool isFlashOn = false;
  MobileScannerController _scanController = MobileScannerController();
  final AddedMedicineRepository _addedMedicineRepo = AddedMedicineRepository();
  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize AudioPlayer

  // Handle barcode scanning
  void _onBarcodeScanned(String barcode) async {
    final String baseId = barcode.substring(0, 5);
    final addedMedicines = await _addedMedicineRepo.getAllAddedMedicines();

    final medicine = addedMedicines.firstWhere(
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

    // If the medicine is not found OR the barcode is NOT in stock, exit
    if (medicine.finalMedicine.id.isEmpty ||
        !medicine.scannedBarcodes.contains(barcode)) {
      return; // Do nothing if the medicine isn't found or the barcode is not in stock
    }

    // If the medicine is found
    if (!scannedBarcodes.contains(barcode)) {
      setState(() {
        final existingItemIndex = scannedItems.indexWhere(
          (item) => item['id'].startsWith(baseId),
        );

        if (existingItemIndex != -1) {
          scannedItems[existingItemIndex]['quantity'] += 1;
          scannedItems[existingItemIndex]['scannedBarcodes'].add(barcode);
        } else {
          scannedItems.add({
            'id': medicine.finalMedicine.id,
            'name': medicine.finalMedicine.medicine.productName,
            'quantity': 1,
            'price': medicine.finalMedicine.medicine.price,
            'scannedBarcodes': [barcode],
          });
        }

        scannedBarcodes.add(barcode);
      });

      // Play the scan sound
      await _audioPlayer.play(AssetSource('sound/scan-success.mp3'));
    }
  }

  // Calculate total amount
  double get totalAmount => scannedItems.fold(
        0.0,
        (sum, item) => sum + (item['price'] ?? 0.0) * (item['quantity'] ?? 1),
      );

  // Remove an item
  void _removeItem(int index) {
    setState(() {
      final baseId = scannedItems[index]['id'];
      scannedBarcodes.removeWhere((barcode) => barcode.startsWith(baseId));
      scannedItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
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
              if (barcode.barcodes.first.rawValue != null) {
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
                          return ListTile(
                            title: Text(
                              item['name'] ?? 'Unknown',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Quantity: ${item['quantity']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeItem(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: ₹${totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (scannedItems.isEmpty) {
                              // Show a message if no items are scanned
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('No items scanned!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              // Proceed to the next screen
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => CustomerDetailsPage(
                                    scannedItems: scannedItems,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text(
                            'Done',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
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