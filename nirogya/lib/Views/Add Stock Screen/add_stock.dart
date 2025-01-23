import 'package:flutter/material.dart';
import 'package:nirogya/Widget/image_picker.dart';


class AddProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Add Product"),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Product Name
                  _buildInputField(
                    label: "Product Name",
                    hintText: "e.g., Paracetamol",
                    required: true,
                  ),
                  SizedBox(height: 10),

                  // Price and Quantity
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: "Price",
                          hintText: "\$100",
                          required: true,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildInputField(
                          label: "Quantity",
                          hintText: "e.g., 50",
                          required: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Expiry Date and Batch
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: "Expiry Date",
                          hintText: "MM/YYYY",
                          required: true,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildInputField(
                          label: "Batch",
                          hintText: "Batch123",
                          required: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Image and Dealer Name
                  Row(
                    children: [
                      Expanded(
                        child: CustomFilePicker(
                          label: "Image (Upload)",
                          isRequired: false,
                          onFileSelected: (path) {
                            // Handle the file path (e.g., upload or save)
                            print("Selected File: $path");
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildDropdownField(
                          label: "Dealer Name",
                          hintText: "Select Dealer",
                          required: true,
                          items: ["Dealer A", "Dealer B", "Dealer C"],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Company Name and Alert Quantity
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: "Company Name",
                          hintText: "e.g., PharmaCorp",
                          required: false,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildInputField(
                          label: "Alert Quantity",
                          hintText: "e.g., 10",
                          required: false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Description
                  _buildInputField(
                    label: "Description",
                    hintText: "Enter product description...",
                    required: false,
                    isFullWidth: true,
                  ),
                  SizedBox(height: 20),

                  // Current Inventory Section
                  _buildSectionHeading("Current Inventory"),
                  SizedBox(height: 15),
                  _buildInventoryDetails(
                    name: "Paracetamol",
                    price: "\$50",
                    quantity: "100",
                    batch: "Batch123",
                    expiry: "12/2025",
                  ),
                ],
              ),
            ),
          ),
          // Save Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Add save functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    bool required = false,
    bool isFullWidth = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            children: [
              if (required)
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red.shade200, width: 1),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red.shade200, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required List<String> items,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            children: [
              if (required)
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red.shade200, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
          ),
          items: items
              .map((item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildSectionHeading(String text) {
    return Container(
      decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Color(0xff920000), width: 3))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: const Text(
          'Current Inventory',
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildInventoryDetails({
    required String name,
    required String price,
    required String quantity,
    required String batch,
    required String expiry,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        Text(
          "Name",
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),

        // Price and Quantity
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Price",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                Text(
                  price,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quantity",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                Text(
                  quantity,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),

        // Batch and Expiry
        Text(
          "Batch",
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        Text(
          batch,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),

        Text(
          "Expiry",
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        Text(
          expiry,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
