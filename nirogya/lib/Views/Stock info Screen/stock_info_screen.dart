import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../Edit Stock Page/edit_stock_page.dart';
import '../../Model/Scanned Medicine/scanned_medicine.dart'; // Import the ScannedMedicine model
import '../../Data/Added Medicine/added_medicine_repo.dart'; // Import the Added Medicine repository

class StockInfoScreen extends StatefulWidget {
  final ScannedMedicine medicine; // Accept the medicine instance

  StockInfoScreen({required this.medicine}); // Constructor

  @override
  _StockInfoScreenState createState() => _StockInfoScreenState();
}

class _StockInfoScreenState extends State<StockInfoScreen> {
  final AddedMedicineRepository _addedMedicineRepo =
      AddedMedicineRepository(); // Added Medicine repository

  @override
  Widget build(BuildContext context) {
    final medicine = widget.medicine; // Access the passed medicine instance

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Stock Info",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.edit, color: Color(0xff920000)),
        //     onPressed: () {
        //       // Edit action
        //       Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (context) => EditStockPage(
        //             medicine: medicine,
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: Column(
        children: [
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.file(
                      File(medicine.finalMedicine.medicine.imagePath!),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/no_preview_img.webp", // Fallback image
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 16),

                  // Medicine Name
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Color(0xff920000), width: 3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        medicine.finalMedicine.medicine
                            .productName, // Display medicine name
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Description", style: _labelStyle),
                      SizedBox(height: 4),
                      Text(medicine.finalMedicine.medicine.description!,
                          style: _valueStyle), // Display description
                    ],
                  ),

                  SizedBox(height: 16),

                  // Price and Batch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      _buildLabelValueColumn(
                          "Price", "₹${medicine.finalMedicine.medicine.price}"),

                      // Batch
                      _buildLabelValueColumn(
                          "Batch", medicine.finalMedicine.medicine.batch),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Quantity and Expiry
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabelValueColumn("Quantity",
                          medicine.finalMedicine.medicine.quantity.toString()),
                      _buildLabelValueColumn(
                          "Expiry", medicine.finalMedicine.medicine.expiryDate),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Alert Quantity and Dealer Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabelValueColumn(
                          "Alert Quantity",
                          medicine.finalMedicine.medicine.alertQuantity
                              .toString()),
                      _buildLabelValueColumn("Dealer Name",
                          medicine.finalMedicine.medicine.dealerName),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Company and QR Code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabelValueColumn("Company",
                          medicine.finalMedicine.medicine.companyName!),
                      _buildLabelValueColumn("QR Code",
                          "Yes"), // Assuming QR code is always present
                    ],
                  ),

                  SizedBox(height: 16),

                  // Salt Composition
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Salt Composition", style: _labelStyle),
                      SizedBox(height: 4),
                      Text(medicine.finalMedicine.medicine.description!,
                          style: _valueStyle), // Display salt composition
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Full-Width Delete Button at the Bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: SizedBox(
              width: double.infinity, // Full width
              child: ElevatedButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Delete Stock",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for label-value columns
  Widget _buildLabelValueColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle),
          SizedBox(height: 4),
          Text(value, style: _valueStyle),
        ],
      ),
    );
  }

  // Text styles
  final TextStyle _labelStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey.shade600,
    fontWeight: FontWeight.w500,
  );

  final TextStyle _valueStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  // Show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Stock"),
          content: Text("Are you sure you want to delete this stock?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteStock(); // Delete the stock
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Delete the stock
  void _deleteStock() async {
    // Delete the medicine
    await _addedMedicineRepo
        .deleteAddedMedicine(widget.medicine.finalMedicine.id);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Stock deleted successfully.")),
    );

    // Navigate back
    Navigator.pop(context);
  }
}
