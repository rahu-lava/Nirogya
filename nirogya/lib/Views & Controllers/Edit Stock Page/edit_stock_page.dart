import 'package:flutter/material.dart';

class EditStockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? actionConfirmation;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Edit Stock"),
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
                  const SizedBox(height: 10),

                  // Action Confirmation Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Confirm Action",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          children: const [
                            TextSpan(
                              text: " *",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      DropdownButtonFormField<String>(
                        value: actionConfirmation,
                        decoration: InputDecoration(
                          hintText: "Select Action",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.red.shade200, width: 1),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                        items: ["Save Changes", "Delete Stock"].map((action) {
                          return DropdownMenuItem<String>(
                            value: action,
                            child: Text(action),
                          );
                        }).toList(),
                        onChanged: (value) {
                          actionConfirmation = value;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Save and Delete Buttons
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (actionConfirmation == "Save Changes") {
                        // Save functionality here
                        print("Stock updated successfully.");
                        Navigator.pop(context);
                      } else {
                        _showConfirmationDialog(context, "Save Changes");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (actionConfirmation == "Delete Stock") {
                        // Delete functionality here
                        print("Stock deleted successfully.");
                        Navigator.pop(context);
                      } else {
                        _showConfirmationDialog(context, "Delete Stock");
                      }
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
                      "Delete",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
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

  void _showConfirmationDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Action Required"),
          content: Text(
              "Please confirm your action before proceeding with $action."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
