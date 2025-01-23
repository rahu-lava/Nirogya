import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../Edit Stock Page/edit_stock_page.dart';

class StockInfoScreen extends StatefulWidget {
  @override
  _StockInfoScreenState createState() => _StockInfoScreenState();
}

class _StockInfoScreenState extends State<StockInfoScreen> {
  String selectedBatch = "Batch A"; // Initial batch value

  @override
  Widget build(BuildContext context) {
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
                  MaterialPageRoute(builder: (context) => EditStockPage()));
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
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  "assets/images/no_preview_img.webp", // Replace with your image URL
                  fit: BoxFit.contain,
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
                    "Medicine Name",
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
                  Text("This is a medicine description.", style: _valueStyle),
                ],
              ),

              SizedBox(height: 16),

              // Price and Batch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  _buildLabelValueColumn("Price", "₹200"),

                  // Batch
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Batch", style: _labelStyle),
                        // SizedBox(height: 4),
                        Container(
                          // color: Colors.red,
                          height: 30,
                          padding: EdgeInsets.zero,
                          child: DropdownButton<String>(
                            padding: EdgeInsets.all(0),
                            value: selectedBatch,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedBatch = newValue ?? "";
                                // Update certain values based on the selected batch
                              });
                            },
                            items:
                                ["Batch A", "Batch B", "Batch C"].map((batch) {
                              return DropdownMenuItem(
                                value: batch,
                                child: Text(batch, style: _valueStyle),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Quantity and Expiry
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabelValueColumn("Quantity", "50"),
                  _buildLabelValueColumn("Expiry", "12/2025"),
                ],
              ),

              SizedBox(height: 16),

              // Alert Quantity and Dealer Name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabelValueColumn("Alert Quantity", "10"),
                  _buildLabelValueColumn("Dealer Name", "ABC Pharma"),
                ],
              ),

              SizedBox(height: 16),

              // Company and QR Code
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabelValueColumn("Company", "XYZ Ltd."),
                  _buildLabelValueColumn("QR Code", "Yes"),
                ],
              ),

              SizedBox(height: 16),

              // Salt Composition
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Salt Composition", style: _labelStyle),
                  SizedBox(height: 4),
                  Text("Paracetamol 500mg", style: _valueStyle),
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
