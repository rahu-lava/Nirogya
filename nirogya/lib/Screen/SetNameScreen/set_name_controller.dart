import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:nirogya/Auth/auth_provider.dart';
import 'package:provider/provider.dart';

class setNameController {
  Future<bool> setUsername(BuildContext context, String name) async {
    AuthProvider authProvider = context.read<AuthProvider>();

    Client client = authProvider.client;
    final account = Account(client);

    try {
      final response = await account.updateName(name: name);
      return true;
    } catch (e) {
      print("Your Error is $e ");
      return false;
    }
  }
}
