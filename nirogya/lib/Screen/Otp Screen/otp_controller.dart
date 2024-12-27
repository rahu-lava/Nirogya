import 'dart:js';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:nirogya/Auth/auth_provider.dart';
import 'package:nirogya/Screen/Login%20Screen/login_controller.dart';
import 'package:provider/provider.dart';

class OtpController {
  Future<bool> onResendOtp(BuildContext context, String number) async {
    Future<bool> result = LoginController().sendOtp(
        context, number.substring(1, 4), number.substring(number.length - 3));

    return result;
  }

  Future<bool> onVerifyOtp(BuildContext context, String otp) async {
    AuthProvider authProvider = context.read<AuthProvider>();
    Client client = authProvider.client;
    Account account = Account(client);

    try {
      await account.createSession(userId: authProvider.userID, secret: otp);
      return true;
    } catch (e) {
      print("Your Error is $e ");
      return false;
    }
  }

  String morphPhoneNumber(String phoneNumber) {
    // Ensure the number has at least 10 digits
    if (phoneNumber.length < 10) {
      throw ArgumentError("Phone number must have at least 10 digits.");
    }

    // Extract parts
    String prefix = phoneNumber.substring(0, 6); // First 7 characters
    String suffix =
        phoneNumber.substring(phoneNumber.length - 3); // Last 3 characters

    // Construct morphed number
    return '$prefix****$suffix';
  }
}
