import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0, // Remove shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Terms &',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF920000), // Hex color #92000
              ),
            ),
            const Text(
              'Condition',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF920000), // Hex color #92000
              ),
            ),
            const SizedBox(height: 20),

            // Terms and Conditions Content
            Expanded(
              child: SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            'Welcome to our application. Please read these terms and conditions carefully before using our services.\n\n',
                      ),
                      TextSpan(
                        text: '1. Acceptance of Terms: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            'By accessing and using this application, you agree to be bound by these terms. If you do not agree, please refrain from using the application.\n\n',
                      ),
                      TextSpan(
                        text: '2. User Conduct: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            'You agree to use the application for lawful purposes only. Any misuse, including but not limited to hacking, distributing malicious software, or engaging in illegal activities, is strictly prohibited.\n\n',
                      ),
                      TextSpan(
                        text: '3. Intellectual Property: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            'All content, logos, and design elements within this application are the intellectual property of our organization. Unauthorized reproduction or use is not permitted.\n\n',
                      ),
                      TextSpan(
                        text: '4. Privacy Policy: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            'We are committed to protecting your privacy. By using our application, you consent to our data collection and usage practices as outlined in our Privacy Policy.\n\n',
                      ),
                      TextSpan(
                        text: '5. Limitation of Liability: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            'We strive to provide accurate information, but we cannot guarantee the application\'s reliability or accuracy. We are not liable for any damages resulting from the use of this application.\n\n',
                      ),
                      TextSpan(
                        text: '6. Modifications: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            'We reserve the right to modify these terms at any time. Continued use of the application after changes signifies your acceptance of the updated terms.\n\n',
                      ),
                      TextSpan(
                        text: '7. Termination: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            'We reserve the right to terminate your access to the application without prior notice if you violate these terms.\n\n',
                      ),
                      TextSpan(
                        text: '8. Governing Law: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            'These terms are governed by the laws of [Your Jurisdiction]. Any disputes shall be resolved under its exclusive jurisdiction.\n\n',
                      ),
                      const TextSpan(
                        text:
                            'Thank you for choosing our application. If you have any questions regarding these terms, feel free to contact our support team.\n',
                      ),
                    ],
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
