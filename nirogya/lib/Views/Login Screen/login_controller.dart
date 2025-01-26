import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:nirogya/View%20Model/Auth/auth_view_model.dart';
import 'package:provider/provider.dart';

class LoginController {
  Future<bool> sendOtp(
      BuildContext context, String countryCode, String number) async {
    AuthViewModel authProvider = context.read<AuthViewModel>();

    Client client = authProvider.client;
    final account = Account(client);

    try {
      final token = await account.createPhoneToken(
          userId: ID.unique(), phone: countryCode + number);
      authProvider.setUserID(token.userId);
      authProvider.setNumber(countryCode + number);
      return true;
    } catch (e) {
      print("Your Error is $e ");
      return false;
    }
  }
}
