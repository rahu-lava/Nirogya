import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';
import '../../Model/Dealer/dealer.dart';
import '../../Model/Medicine/medicine.dart';
import '../../View Model/Add Purchase/add_purchase_view_model.dart';
import '../../View Model/Dealer/dealer_view_model.dart';
import '../../Widget/image_picker.dart';
import '../Add Dealer Screen/add_dealer.dart';
import '../Purchase List/purchase_product_list.dart';

class PurchaseBillPage extends StatefulWidget {
  @override
  _PurchaseBillPageState createState() => _PurchaseBillPageState();
}

class _PurchaseBillPageState extends State<PurchaseBillPage> {
  String? selectedDealer;
  late DealerViewModel dealerProvider;
  bool _isLoading = true;
  String? expiryDate;
  String? imagePath;
  // String dateText = "MM/YYYY";

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController alertQuantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> _initializeDealers() async {
    dealerProvider = context.read<DealerViewModel>();
    try {
      await dealerProvider.fetchDealers();
    } catch (e) {
      print("Error fetching dealers: $e");
    } finally {
      setState(() {
        _isLoading = false; // Update loading state
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeDealers();
    // fetchDealer(context);
  }

  @override
  void dispose() {
    // Dispose controllers
    productNameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    batchController.dispose();
    companyNameController.dispose();
    alertQuantityController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

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
                    controller: productNameController,
                  ),
                  const SizedBox(height: 10),

                  // Price and Quantity
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputFieldNum(
                          label: "Price",
                          hintText: "\$100",
                          required: true,
                          controller: priceController,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInputFieldNum(
                            label: "Quantity",
                            hintText: "e.g., 50",
                            required: true,
                            controller: quantityController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Expiry Date and Batch
                  Row(
                    children: [
                      Expanded(
                        child: _buildDatePickerField(
                          label: "Expiry Date",
                          hintText: "DD/MM/YYYY",
                          required: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInputField(
                            label: "Batch",
                            hintText: "Batch123",
                            required: true,
                            controller: batchController),
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
                            imagePath = path;
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
                            controller: companyNameController),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInputFieldNum(
                            label: "Alert Quantity",
                            hintText: "e.g., 10",
                            required: false,
                            controller: alertQuantityController),
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
                      controller: descriptionController),
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
                  final purchaseViewModel = context.read<PurchaseViewModel>();

                  purchaseViewModel.saveProduct(
                    context: context,
                    productName: productNameController.text,
                    price: priceController.text,
                    quantity: quantityController.text,
                    batch: batchController.text,
                    expiryDate: expiryDate,
                    dealerName: selectedDealer,
                    imagePath: imagePath ?? "",
                    companyName: companyNameController.text,
                    alertQuantity: alertQuantityController.text,
                    description: descriptionController.text,
                  );
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
    // DealerProvider dealerProvider = context.read<DealerProvider>();
    final dealerProvider = Provider.of<DealerViewModel>(context);
    // print(taskProvider.dealers.length);
    List<Dealer> dealers = dealerProvider.dealers;

    Dealer dealerAdd = Dealer(
        name: "Add New Dealer",
        contactNumber: "1234567890",
        gstin: "gstin",
        hasWhatsApp: false);
    List<Dealer> dealer = [dealerAdd];

    dealers += dealer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label for the dropdown
        const Text.rich(
          TextSpan(
            text: "Dealer Name",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
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
              value: dealer.name,
              child: Text(dealer.name),
            );
          }).toList(),
          onChanged: (value) {
            if (value == "Add New Dealer") {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const AddDealerScreen()),
              );
            } else {
              setState(() {
                selectedDealer = value;
              });
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
    TextEditingController? controller,
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
            // enabled: false,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputFieldNum({
    required String label,
    required String hintText,
    bool required = false,
    bool isFullWidth = false,
    TextEditingController? controller,
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
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Allows only digits
          ],
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red.shade200, width: 1),
            ),
            // enabled: false,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required String hintText,
    bool required = false,
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
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              setState(() {
                expiryDate = DateFormat("DD/MM/yyyy").format(pickedDate);
              });
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.shade200, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              expiryDate ?? hintText,
              style: TextStyle(
                color: expiryDate == null ? Colors.grey : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
