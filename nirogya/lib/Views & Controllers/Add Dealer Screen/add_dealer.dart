import 'package:flutter/material.dart';
import 'package:nirogya/Model/Dealer/dealer.dart';
import 'package:nirogya/Provider/Dealer/dealer_provider.dart';
import 'package:nirogya/Views%20&%20Controllers/Add%20Dealer%20Screen/dealer_controller.dart';
import 'package:provider/provider.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

class AddDealerScreen extends StatefulWidget {
  const AddDealerScreen({Key? key}) : super(key: key);

  @override
  State<AddDealerScreen> createState() => _AddDealerScreenState();
}

class _AddDealerScreenState extends State<AddDealerScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController gstinController = TextEditingController();
  bool isWhatsAppSame = false;

  void _proceed() {
    if (nameController.text.isNotEmpty &&
        contactController.text.isNotEmpty &&
        gstinController.text.isNotEmpty) {
      // final dealerRepo = DealerController();
      // DealerProvider dealerProvider = context.read<DealerProvider>();

      final newDealer = Dealer(
          name: nameController.text.trim(),
          contactNumber: contactController.text.trim(),
          gstin: gstinController.text.trim(),
          hasWhatsApp: isWhatsAppSame);

      Provider.of<DealerProvider>(context, listen: false)
          .addDealer(newDealer)
          .then((_) {
        if (Provider.of<DealerProvider>(context, listen: false).status) {
          ToastService.showSuccessToast(
            context,
            length: ToastLength.medium,
            message: "Dealer saved successfully!",
          );
        } else {
          ToastService.showErrorToast(
            context,
            length: ToastLength.medium,
            message: "Failed to save the details!",
          );
        }
      });
    } else {
      // Show a warning if any field is empty
      ToastService.showWarningToast(
        context,
        length: ToastLength.medium,
        message: "Please fill all fields! ",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Dealer'),
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
                hintText: 'Enter dealer name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Contact Input
            const Text(
              'Contact Number',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: contactController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter dealer contact number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: isWhatsAppSame,
                  onChanged: (value) {
                    setState(() {
                      isWhatsAppSame = value!;
                    });
                  },
                ),
                const Text('WhatsApp number is the same'),
              ],
            ),
            const SizedBox(height: 20),

            // GSTIN Input
            const Text(
              'GSTIN Number',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: gstinController,
              decoration: InputDecoration(
                hintText: 'Enter GSTIN number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
              ),
            ),
            const Spacer(),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _proceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14), // Ensures the button is long and wide
                ),
                child: const Text(
                  'Proceed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
