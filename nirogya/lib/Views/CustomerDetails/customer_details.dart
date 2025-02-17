import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nirogya/Data/Sales Bill/sales_bill_repo.dart';
import 'package:nirogya/Model/Sales Bill/sales_bill.dart';
import 'package:nirogya/Data/Added Medicine/added_medicine_repo.dart';
import 'package:nirogya/Model/Medicine/medicine.dart';
import 'package:nirogya/Model/Scanned Medicine/scanned_medicine.dart'; // Import ScannedMedicine model
import 'package:nirogya/Utils/testing_utils.dart';
import '../../Utils/mobilePdfDownloader.dart';
import '../../Utils/sales_bill_pdf.dart'; // Import the PDF utility
import '../../Utils/webPdfDownloader.dart';

class CustomerDetailsPage extends StatefulWidget {
  final List<Map<String, dynamic>> scannedItems;

  const CustomerDetailsPage({Key? key, required this.scannedItems})
      : super(key: key);

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  String selectedPaymentOption = "Online";
  String? invoiceNumber; // Store the generated invoice number

  // Save the sales bill and update the Added Medicine repository
  Future<void> _saveSalesBill() async {
    final addedMedicineRepo = AddedMedicineRepository();

    // Fetch full details of each medicine using its ID
    final List<Medicine> medicines = [];
    for (var item in widget.scannedItems) {
      final medicine = await addedMedicineRepo.getAddedMedicineById(item['id']);
      if (medicine != null) {
        // Add the full medicine details to the list
        final medicineCopy = Medicine(
          productName: medicine.finalMedicine.medicine.productName,
          price: medicine.finalMedicine.medicine.price,
          quantity: item['quantity'], // Use the quantity from scannedItems
          expiryDate: medicine.finalMedicine.medicine.expiryDate,
          batch: medicine.finalMedicine.medicine.batch,
          dealerName: medicine.finalMedicine.medicine.dealerName,
          gst: medicine.finalMedicine.medicine.gst,
          companyName: medicine.finalMedicine.medicine.companyName,
          alertQuantity: medicine.finalMedicine.medicine.alertQuantity,
          description: medicine.finalMedicine.medicine.description,
          imagePath: medicine.finalMedicine.medicine.imagePath,
        );
        medicines.add(medicineCopy);

        // Remove the scanned barcodes from the medicine
        final scannedBarcodes = item['scannedBarcodes'] ?? [];
        medicine.scannedBarcodes
            .removeWhere((barcode) => scannedBarcodes.contains(barcode));

        // Update the quantity in the repository
        medicine.finalMedicine.medicine.quantity -= item['quantity'] as int;

        // If the quantity is zero, remove the medicine
        if (medicine.finalMedicine.medicine.quantity <= 0) {
          await addedMedicineRepo.deleteAddedMedicine(item['id']);
        } else {
          // Update the medicine in the repository
          await addedMedicineRepo.updateAddedMedicine(medicine);
        }
      }
    }

    // Generate the invoice number
    invoiceNumber = SalesBillPdfUtils.generateInvoiceNumber();

    // Save the sales bill
    final salesBill = SalesBill(
      invoiceNumber: invoiceNumber!,
      date: DateTime.now(),
      medicines:
          medicines, // Use the full medicine details with correct quantity
      customerName: nameController.text.isNotEmpty ? nameController.text : '-',
      customerContactNumber:
          numberController.text.isNotEmpty ? numberController.text : '-',
      paymentMethod: selectedPaymentOption,
    );

    await SalesBillRepository.saveSalesBill(salesBill);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sales bill saved successfully!')),
    );

    // Show the dialog after saving the bill
    _showDialog(context);
  }

  // Show the dialog for WhatsApp or Print
  void _showDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select Option",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // WhatsApp Option
                    GestureDetector(
                      onTap: () async {
                        // Generate the PDF and share via WhatsApp
                        final pdfBytes =
                            await SalesBillPdfUtils.generateSalesBillPdf(
                          invoiceNumber:
                              invoiceNumber!, // Pass the invoice number
                        );

                        if (kIsWeb) {
                          WebPdfDownloader.webpdfDownload(pdfBytes, true);
                        } else {
                          MobilePdfDownloader.mobilePdfDownload(pdfBytes, true);
                        }

                        // Close the dialog and the current screen
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 120, // Fixed width for both containers
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xff920000),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/whatsapp_white.png',
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Whatsapp",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Print Option
                    GestureDetector(
                      onTap: () async {
                        // Generate the PDF for printing
                        final pdfBytes =
                            await SalesBillPdfUtils.generateSalesBillPdf(
                          invoiceNumber:
                              invoiceNumber!, // Pass the invoice number
                        );

                        if (kIsWeb) {
                          WebPdfDownloader.webpdfDownload(pdfBytes, false);
                        } else {
                          MobilePdfDownloader.mobilePdfDownload(
                              pdfBytes, false);
                        }

                        // Close the dialog and the current screen
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 120, // Fixed width for both containers
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xff920000),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/printer.png',
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Print",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xff920000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Input
            const Text(
              'Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter customer name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Number Input
            const Text(
              'Phone Number',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter customer phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Payment Option Dropdown
            const Text(
              'Payment Option',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: selectedPaymentOption,
              items: const [
                DropdownMenuItem(value: 'Online', child: Text('Online')),
                DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                DropdownMenuItem(value: 'Pay Later', child: Text('Pay Later')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPaymentOption = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
              ),
            ),
            const Spacer(),

            // Bottom Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button
                TextButton(
                  onPressed: () {
                    _saveSalesBill(); // Save the sales bill with "-" for customer details
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Proceed Button
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        numberController.text.isNotEmpty &&
                        selectedPaymentOption.isNotEmpty) {
                      _saveSalesBill(); // Save the sales bill
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Proceed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
