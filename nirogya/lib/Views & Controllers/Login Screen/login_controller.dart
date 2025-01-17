import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:nirogya/Provider/Auth/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginController {
  Future<bool> sendOtp(
      BuildContext context, String countryCode, String number) async {
    AuthProvider authProvider = context.read<AuthProvider>();

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
