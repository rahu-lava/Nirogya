import 'package:flutter/material.dart';

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
      // All fields are filled
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Proceed'),
            content: const Text(
                'Dealer information has been saved. Proceeding to the next step.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Add further action logic here
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        },
      );
    } else {
      // Show a warning if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields!'),
          backgroundColor: Colors.red,
        ),
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
