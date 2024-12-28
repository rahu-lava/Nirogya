// import 'dart:js';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nirogya/Auth/auth_provider.dart';
import 'package:nirogya/Screen/Home/home.dart';
import 'package:nirogya/Screen/Login%20Screen/login_controller.dart';
import 'package:nirogya/Screen/SetNameScreen/set_name.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpController {
  Future<bool> onResendOtp(BuildContext context, String number) async {
    Future<bool> result = LoginController().sendOtp(
        context, number.substring(0, 4), number.substring(4, number.length));

    return result;
  }

  Future<bool> onVerifyOtp(BuildContext context, String otp) async {
    AuthProvider authProvider = context.read<AuthProvider>();
    Client client = authProvider.client;

    Account account = Account(client);

    try {
      await account.createSession(userId: authProvider.userID, secret: otp);
      User user = await account.get();
      String name = user.name;
      print("your name is : " + name.length.toString());
      if (name.length == 0) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SetName(),
        ));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      }

      // await account.deleteSession(sessionId: "current");

      // User user = await account.get();
      // print("The user is : " + user.name.toString());
      // if (true) {
      //   // print('User is logged in: ${user.name}');
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (context) => HomePage(),
      //     ),
      //   );
      // } else {
      // await account.deleteSession(sessionId: "current");
      //   await account.createSession(userId: authProvider.userID, secret: otp);
      //   print('Username is not set, logging out.');
      //   Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => SetName(),
      //   ));
      //   // _isLogged = false;
      // }
      // // SessionList sessions = await account.listSessions();
      // print("The sessions are : " + sessions.toString());
      // if (account.get() != null) {
      //   await account.deleteSessions();
      // }
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
