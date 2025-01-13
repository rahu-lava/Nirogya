import 'package:flutter/material.dart';

class CustomerDetailsPage extends StatefulWidget {
  const CustomerDetailsPage({Key? key}) : super(key: key);

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  String selectedPaymentOption = "Online";

  void _showDialog(String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an action for $action'),
          content: const Text('Would you like to share via WhatsApp or print?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add WhatsApp logic here
              },
              child: const Text(
                'WhatsApp',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add Print logic here
              },
              child: const Text(
                'Print',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
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
                    _showDialog('Skip');
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
                      _showDialog('Proceed');
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
