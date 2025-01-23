import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:nirogya/View%20Model/Auth/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import '../Feedback Screen/feedback_screen.dart';
import '../Login Screen/login.dart';
import '../Terms&Condition Screen/terms_and_condition_screen.dart'; // For context.read<AuthProvider>()

// Replace with your AuthProvider, ToastService, and LoginScreen imports
// import 'auth_provider.dart';
// import 'toast_service.dart';
// import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationOn = true;

  void _logOut() {
    AuthProvider authProvider = context.read<AuthProvider>();
    Client client = authProvider.client;
    Account account = Account(client);
    authProvider.setLogged(false);

    try {
      account.deleteSession(sessionId: "current").then((value) {
        ToastService.showSuccessToast(context,
            length: ToastLength.medium,
            expandedHeight: 100,
            message: "Logged Out Successfully");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      });
    } catch (e) {
      // print(e);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Widget _buildOption(String path, String text,
      {Widget? trailing,
      GestureTapCallback? onTap,
      Color textColor = Colors.black}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(path, width: 24, height: 24),
                const SizedBox(width: 20),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: textColor,
                  ),
                ),
              ],
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Notification Option
          _buildOption(
            'assets/images/notification.png', // Replace with your notification icon path
            'Notification',
            trailing: Container(
              height: 15,
              child: Checkbox(
                value: isNotificationOn,
                onChanged: (value) {
                  setState(() {
                    isNotificationOn = value!;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
          ),

          // Feedback Option
          _buildOption(
            'assets/images/feedback.png', // Replace with your feedback icon path
            'Feedback',
            onTap: () {
              // Add feedback functionality here
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FeedbackScreen()));
            },
          ),

          // Terms & Conditions Option
          _buildOption(
            'assets/images/t&c.png', // Replace with your terms icon path
            'Terms & Conditions',
            onTap: () {
              // Add terms functionality here
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TermsAndConditionsScreen()));
            },
          ),

          // Log Out Option
          _buildOption(
            'assets/images/log_out.png', // Replace with your logout icon path
            'Log Out',
            onTap: _logOut,
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
