import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

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
              'About',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF920000), // Hex color #92000
              ),
            ),
            const Text(
              'Us',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF920000), // Hex color #92000
              ),
            ),
            const SizedBox(height: 20),

            // About Us Content
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
                      const TextSpan(text: 'Welcome to '),
                      TextSpan(
                        text: 'Nirogya',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF920000)),
                      ),
                      const TextSpan(
                        text:
                            ', where innovation meets simplicity. We are committed to providing you with an intuitive and efficient platform tailored to meet your specific needs.\n\n',
                      ),
                      const TextSpan(
                        text: 'Our Mission: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            'To simplify and enhance your daily operations with cutting-edge technology and exceptional user experience. We aim to empower our users by offering tools that are both powerful and easy to use.\n\n',
                      ),
                      const TextSpan(
                        text: 'What We Do: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            'Our application is designed with a focus on user-centric features, offering solutions for [specific functions, e.g., inventory management, sales tracking, etc.]. We believe in continuous improvement and are dedicated to evolving with your needs.\n\n',
                      ),
                      const TextSpan(
                        text: 'Why Choose Us?\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            '- Innovation: We utilize the latest technology to stay ahead of the curve.\n'
                            '- Reliability: Trust is the foundation of our service.\n'
                            '- Support: Our dedicated team is here to assist you at every step.\n\n',
                      ),
                      const TextSpan(
                        text: 'Our Vision: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            'To become a leading name in providing efficient, reliable, and scalable solutions for businesses and individuals across various domains.\n\n',
                      ),
                      const TextSpan(
                        text:
                            'Thank you for being a part of our journey. We look forward to growing and succeeding together. For inquiries or support, feel free to reach out to us.\n\n',
                      ),
                      const TextSpan(
                        text: 'Contact Us: \n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            'Email: support@[yourapp].com\nPhone: +1 (123) 456-7890',
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
