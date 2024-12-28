import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nirogya/Auth/auth_provider.dart';
import 'package:nirogya/Screen/Splash%20Screen/SplashScreen.dart';
import 'package:nirogya/Screen/Splash%20Screen/model/auth_model.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [AuthModelSchema],
    directory: dir.path,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider(isar)),
  ], child: MyApp(isar: isar)));
}

class MyApp extends StatelessWidget {
  final Isar isar;

  const MyApp({super.key, required this.isar});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: "Poppins"),
      home: SplashScreen(),
    );
  }
}
