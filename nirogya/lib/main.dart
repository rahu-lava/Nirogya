import 'package:flutter/material.dart';
import 'package:nirogya/Auth/auth_provider.dart';
import 'package:nirogya/Screen/Home/home.dart';
import 'package:nirogya/Screen/Splash%20Screen/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Poppins"),
      home: HomePage(),
    );
  }
}
