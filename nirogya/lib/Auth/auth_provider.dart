import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  late Client _client;
  late Account _account;
  late String _userID;
  late String _number;

  AuthProvider() {
    _client = Client();
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('676df1f9003cc6b68c0b')
        .setSelfSigned(status: true); // Remove in production
    _account = Account(_client);
  }

  Client get client => _client;
  Account get account => _account;
  String get userID => _userID;
  String get number => _number;

  void setUserID(String userID) {
    _userID = userID;
    notifyListeners();
  }

  int setNumber(String number) {
    print("Your Number is $number");
    _number = number;
    notifyListeners();
    return 1;
  }
}
