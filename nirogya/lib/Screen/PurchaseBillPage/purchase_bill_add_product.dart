import 'package:flutter/material.dart';
import 'package:nirogya/Screen/DealersDetail/dealers_detail.dart';
import 'package:nirogya/Screen/Home/widget/image_picker.dart';
import 'package:nirogya/Screen/Purchase%20Product%20List/purchase_product_list.dart';

class PurchaseBillPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Add Purchase Bill"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Product Name
                  _buildInputField(
                    label: "Product Name",
                    hintText: "e.g., Paracetamol",
                    required: true,
                  ),
                  const SizedBox(height: 10),

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
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInputField(
                          label: "Quantity",
                          hintText: "e.g., 50",
                          required: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

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
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInputField(
                          label: "Batch",
                          hintText: "Batch123",
                          required: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Image and Dealer Name
                  Row(
                    children: [
                      Expanded(
                        child: _buildDealerDropdown(context),
                      ),
                      const SizedBox(width: 10),
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
                    ],
                  ),
                  const SizedBox(height: 10),

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
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInputField(
                          label: "Alert Quantity",
                          hintText: "e.g., 10",
                          required: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Description
                  _buildInputField(
                    label: "Description",
                    hintText: "Enter product description...",
                    required: false,
                    isFullWidth: true,
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => PurchaseProductList()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
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

  Widget _buildDealerDropdown(BuildContext context) {
    String? selectedDealer;
    List<String> dealers = [
      "Dealer A",
      "Dealer B",
      "Dealer C",
      "Add New Dealer"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label for the dropdown
        Text.rich(
          TextSpan(
            text: "Dealer Name",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            children: [
              const TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5), // Space between label and dropdown

        // Dropdown field
        DropdownButtonFormField<String>(
          value: selectedDealer,
          decoration: InputDecoration(
            hintText: "Select Dealer",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red.shade200, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
          ),
          items: dealers.map((dealer) {
            return DropdownMenuItem<String>(
              value: dealer,
              child: Text(dealer),
            );
          }).toList(),
          onChanged: (value) {
            if (value == "Add New Dealer") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddDealerScreen()),
              );
            } else {
              selectedDealer = value;
            }
          },
        ),
      ],
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
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            children: [
              if (required)
                const TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red.shade200, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }
}
