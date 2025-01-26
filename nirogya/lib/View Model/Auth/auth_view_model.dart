import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  late Client _client;
  late Account _account;
  late String _userID;
  late String _number;
  bool _isLogged = false;
  bool _isFirstTime = true;

  // Constructor
  AuthViewModel() {
    print("AuthProvider Constructor");
    _client = Client();
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('676df1f9003cc6b68c0b')
        .setSelfSigned(status: true); // Remove in production
    _account = Account(_client);
    _loadLoginStatus();
    _checkForFirstTime();
  }

  Client get client => _client;
  Account get account => _account;
  String get userID => _userID;
  String get number => _number;
  bool get logged => _isLogged;
  bool get isFirstTime => _isFirstTime;

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

  // Load login status from SharedPreferences
  Future<void> _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLogged =
        prefs.getBool('isLogged') ?? false; // Default to false if not set
    print("Value for Login :" + _isLogged.toString());
    // _userID = prefs.getString('userID') ?? ''; // Default to empty if not set
    // _number = prefs.getString('number') ?? ''; // Default to empty if not set
    notifyListeners();
  }

  // Set login status and save to SharedPreferences
  Future<void> setLogged(bool logged) async {
    _isLogged = logged;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogged', logged); // Save the value

    if (logged) {
      // Optionally store other values, like user ID or phone number
      await prefs.setString('userID', _userID);
      await prefs.setString('number', _number);
    }
  }

  void setFirstTime() async {
    _isFirstTime = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false); // Save the value
  }

  void _checkForFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstTime = prefs.getBool('isFirstTime') ?? true;
    // prefs.getBool('isLogged') ?? false; // Default to false if not set
    print("Value for Intro :" + _isFirstTime.toString());

    notifyListeners();
  }
}
