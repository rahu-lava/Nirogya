import 'package:flutter/material.dart';
import '../../Model/Final Medicine/final_medicine.dart';
import '../../Model/Medicine/medicine.dart';
import '../../Model/Scanned Medicine/scanned_medicine.dart'; // Import the ScannedMedicine model
import '../../Data/Added Medicine/added_medicine_repo.dart'; // Import the Added Medicine repository

class EditStockPage extends StatefulWidget {
  final ScannedMedicine medicine; // Accept the medicine instance

  EditStockPage({required this.medicine}); // Constructor

  @override
  _EditStockPageState createState() => _EditStockPageState();
}

class _EditStockPageState extends State<EditStockPage> {
  final AddedMedicineRepository _addedMedicineRepo = AddedMedicineRepository(); // Added Medicine repository
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  late TextEditingController _productNameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _expiryDateController;
  late TextEditingController _batchController;
  late TextEditingController _companyNameController;
  late TextEditingController _alertQuantityController;
  late TextEditingController _descriptionController;
  String? _actionConfirmation;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing medicine data
    _productNameController = TextEditingController(text: widget.medicine.finalMedicine.medicine.productName);
    _priceController = TextEditingController(text: widget.medicine.finalMedicine.medicine.price.toString());
    _quantityController = TextEditingController(text: widget.medicine.finalMedicine.medicine.quantity.toString());
    _expiryDateController = TextEditingController(text: widget.medicine.finalMedicine.medicine.expiryDate);
    _batchController = TextEditingController(text: widget.medicine.finalMedicine.medicine.batch);
    _companyNameController = TextEditingController(text: widget.medicine.finalMedicine.medicine.companyName);
    _alertQuantityController = TextEditingController(text: widget.medicine.finalMedicine.medicine.alertQuantity.toString());
    _descriptionController = TextEditingController(text: widget.medicine.finalMedicine.medicine.description);
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _productNameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _expiryDateController.dispose();
    _batchController.dispose();
    _companyNameController.dispose();
    _alertQuantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Form(
        key: _formKey, // Form key for validation
        child: Column(
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
                      controller: _productNameController,
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
                            controller: _priceController,
                            required: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInputField(
                            label: "Quantity",
                            hintText: "e.g., 50",
                            controller: _quantityController,
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
                            controller: _expiryDateController,
                            required: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInputField(
                            label: "Batch",
                            hintText: "Batch123",
                            controller: _batchController,
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
                            controller: _companyNameController,
                            required: false,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInputField(
                            label: "Alert Quantity",
                            hintText: "e.g., 10",
                            controller: _alertQuantityController,
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
                      controller: _descriptionController,
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
                          value: _actionConfirmation,
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
                            setState(() {
                              _actionConfirmation = value;
                            });
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
                        if (_actionConfirmation == "Save Changes") {
                          _saveChanges(); // Save changes
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
                        if (_actionConfirmation == "Delete Stock") {
                          _deleteStock(); // Delete stock
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
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
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
          controller: controller,
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

  // Save changes to the medicine
  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      // Update the medicine details
      final updatedMedicine = ScannedMedicine(
        scannedBarcodes: widget.medicine.scannedBarcodes,
        finalMedicine: FinalMedicine(
          id: widget.medicine.finalMedicine.id,
          medicine: Medicine(
            productName: _productNameController.text,
            price: double.parse(_priceController.text),
            quantity: int.parse(_quantityController.text),
            expiryDate: _expiryDateController.text,
            batch: _batchController.text,
            dealerName: widget.medicine.finalMedicine.medicine.dealerName,
            gst: widget.medicine.finalMedicine.medicine.gst,
            companyName: _companyNameController.text,
            alertQuantity: int.parse(_alertQuantityController.text),
            description: _descriptionController.text,
            imagePath: widget.medicine.finalMedicine.medicine.imagePath,
          ),
        ),
      );

      // Save the updated medicine
      await _addedMedicineRepo.updateAddedMedicine(updatedMedicine);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Stock updated successfully.")),
      );

      // Navigate back
      Navigator.pop(context);
    }
  }

  // Delete the medicine
  void _deleteStock() async {
    // Delete the medicine
    await _addedMedicineRepo.deleteAddedMedicine(widget.medicine.finalMedicine.id);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Stock deleted successfully.")),
    );

    // Navigate back
    Navigator.pop(context);
  }
}