import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:nirogya/Auth/auth_provider.dart';
import 'package:nirogya/Screen/Login%20Screen/login.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
          child: Column(
        children: [
          Text("LogOut"),
          TextButton(
              onPressed: () {
                _logOut();
              },
              child: Text("LogOut"))
        ],
      )),
    );
  }

  void _logOut() {
    AuthProvider authProvider = context.read<AuthProvider>();
    Client client = authProvider.client;
    Account account = Account(client);

    account.deleteSession(sessionId: "current").then((value) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));
    });
  }
}
