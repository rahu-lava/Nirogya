import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:nirogya/View%20Model/Auth/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';

class setNameController {
  Future<bool> setUsername(BuildContext context, String name) async {
    AuthViewModel authProvider = context.read<AuthViewModel>();

    Client client = authProvider.client;
    final account = Account(client);

    try {
      await account.updateName(name: name);
      authProvider.setLogged(true);
      ToastService.showSuccessToast(context,
          length: ToastLength.medium,
          expandedHeight: 100,
          message: "Name Updated Successfully");
      return true;
    } catch (e) {
      print("Your Error is $e ");
      return false;
    }
  }
}
