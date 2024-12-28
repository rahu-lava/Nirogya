import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
// import 'package:hive/hive.dart';
import 'package:isar/isar.dart';

import '../Screen/Splash Screen/model/auth_model.dart';

class AuthProvider extends ChangeNotifier {
  late Client _client;
  late Account _account;
  late String _userID;
  late String _number;
  late bool _isLogged = false;
  final Isar _isar;

  AuthProvider(this._isar) {
    _client = Client();
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('676df1f9003cc6b68c0b')
        .setSelfSigned(status: true); // Remove in production
    _account = Account(_client);
    _loadLoggedState();
  }

  Client get client => _client;
  Account get account => _account;
  String get userID => _userID;
  String get number => _number;
  bool get logged => _isLogged;

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

  void setLogged(bool logged) async {
    _isLogged = logged;
    notifyListeners();
    // Save to Isar
    final authEntry = AuthModel()
      ..key = 'isLogged'
      ..value = logged;

    await _isar.writeTxn(() async {
      await _isar.authModels.put(authEntry);
    });
  }

  void _loadLoggedState() async {
    final entry =
        await _isar.authModels.filter().keyEqualTo('isLogged').findFirst();

    _isLogged = entry?.value ?? false; // Default to false if not found
    notifyListeners();

    notifyListeners();
  }
}
