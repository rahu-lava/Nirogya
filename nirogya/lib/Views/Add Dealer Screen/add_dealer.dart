import 'package:flutter/material.dart';
import 'package:nirogya/Model/Dealer/dealer.dart';
import 'package:nirogya/View%20Model/Dealer/dealer_view_model.dart';
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
      final newDealer = Dealer(
        name: nameController.text.trim(),
        contactNumber: contactController.text.trim(),
        gstin: gstinController.text.trim(),
        hasWhatsApp: isWhatsAppSame,
      );

      Provider.of<DealerViewModel>(context, listen: false)
          .addDealer(newDealer)
          .then((_) {
        if (Provider.of<DealerViewModel>(context, listen: false).status) {
          ToastService.showSuccessToast(
            context,
            length: ToastLength.medium,
            message: "Dealer saved successfully!",
          );
          Navigator.pop(context, true);
        } else {
          ToastService.showErrorToast(
            context,
            length: ToastLength.medium,
            message: "Failed to save the details!",
          );
        }
      });
    } else {
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
      resizeToAvoidBottomInset: true, // Adjust layout when the keyboard opens
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _proceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
      ),
    );
  }
}
