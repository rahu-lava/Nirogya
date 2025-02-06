import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../Edit Stock Page/edit_stock_page.dart';
import '../../Model/Scanned Medicine/scanned_medicine.dart'; // Import the ScannedMedicine model

class StockInfoScreen extends StatefulWidget {
  final ScannedMedicine medicine; // Accept the medicine instance

  StockInfoScreen({required this.medicine}); // Constructor

  @override
  _StockInfoScreenState createState() => _StockInfoScreenState();
}

class _StockInfoScreenState extends State<StockInfoScreen> {
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
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Color(0xff920000)),
            onPressed: () {
              // Edit action
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditStockPage(
                    medicine: medicine,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                  _buildLabelValueColumn("Alert Quantity",
                      medicine.finalMedicine.medicine.alertQuantity.toString()),
                  _buildLabelValueColumn("Dealer Name",
                      medicine.finalMedicine.medicine.dealerName),
                ],
              ),

              SizedBox(height: 16),

              // Company and QR Code
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabelValueColumn(
                      "Company", medicine.finalMedicine.medicine.companyName!),
                  _buildLabelValueColumn(
                      "QR Code", "Yes"), // Assuming QR code is always present
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
}
