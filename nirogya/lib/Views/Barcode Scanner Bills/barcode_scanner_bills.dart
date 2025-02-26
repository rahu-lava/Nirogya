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
  List<String> scannedBarcodes =
      []; // Temporary array to track scanned barcodes
  bool isFlashOn = false;
  MobileScannerController _scanController = MobileScannerController();
  final AddedMedicineRepository _addedMedicineRepo =
      AddedMedicineRepository(); // Added Medicine repository

  // Handle barcode scanning
  void _onBarcodeScanned(String barcode) async {
    // Extract the base ID (first 5 characters)
    final String baseId = barcode.substring(0, 5);

    // Fetch all added medicines
    final addedMedicines = await _addedMedicineRepo.getAllAddedMedicines();

    // Find the medicine with the matching base ID
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
    // if (medicine.finalMedicine.id.isNotEmpty) {
    // Check if the barcode is already scanned
    if (!scannedBarcodes.contains(barcode)) {
      setState(() {
        // Check if the medicine is already in the scanned items list
        final existingItemIndex = scannedItems.indexWhere(
          (item) => item['id'].startsWith(baseId),
        );

        if (existingItemIndex != -1) {
          // If the medicine is already in the list, increase its quantity
          scannedItems[existingItemIndex]['quantity'] += 1;

          // Append the scanned barcode to the existing list
          scannedItems[existingItemIndex]['scannedBarcodes'].add(barcode);
        } else {
          // If the medicine is not in the list, add it
          scannedItems.add({
            'id': medicine.finalMedicine.id, // Use the base ID
            'name': medicine.finalMedicine.medicine.productName,
            'quantity': 1,
            'price': medicine.finalMedicine.medicine.price,
            'scannedBarcodes': [barcode], // Include the scanned barcode
          });
        }

        // Add the barcode to the temporary array
        scannedBarcodes.add(barcode);
      });
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
      // Remove the barcodes associated with the medicine
      final baseId = scannedItems[index]['id'];
      scannedBarcodes.removeWhere((barcode) => barcode.startsWith(baseId));

      // Remove the medicine from the list
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
          // Scanner View
          MobileScanner(
            controller: _scanController,
            onDetect: (barcode) {
              if (barcode.barcodes.first.rawValue != null) {
                _onBarcodeScanned(barcode.barcodes.first.rawValue!);
              }
            },
          ),
          // Bottom Sheet with Scanned Items
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
                    // Total Amount and Done Button
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
                            // Pass the scanned items to the CustomerDetailsPage
                            print("printing scanned items ---");
                            print(scannedItems);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => CustomerDetailsPage(
                                  scannedItems: scannedItems,
                                ),
                              ),
                            );
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
