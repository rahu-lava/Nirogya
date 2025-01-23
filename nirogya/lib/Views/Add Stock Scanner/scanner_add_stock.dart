import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nirogya/Views/Added%20Product%20Screen/added_product_list.dart';
import 'package:nirogya/Views/CustomerDetails/customer_details.dart';

class ScannerAddStock extends StatefulWidget {
  @override
  _ScannerAddStockState createState() => _ScannerAddStockState();
}

class _ScannerAddStockState extends State<ScannerAddStock> {
  List<Map<String, dynamic>> scannedItems = [];
  bool isFlashOn = false;
  MobileScannerController _scanController = new MobileScannerController();

  // Dummy function to simulate scanning and adding items
  void _onBarcodeScanned(String barcode) {
    setState(() {
      scannedItems.add({
        "name": "Item ${scannedItems.length + 1}",
        "quantity": 1,
        "price": 100.0,
      });
    });
  }

  // Calculate total amount
  double get totalAmount =>
      scannedItems.fold(0.0, (sum, item) => sum + (item['price'] ?? 0.0));

  // Remove an item
  void _removeItem(int index) {
    setState(() {
      scannedItems.removeAt(index);
    });
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
                                  '₹${item['price']}',
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
                            // Handle "Done" action
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => ProductList()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text('Done'),
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
