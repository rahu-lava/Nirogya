import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nirogya/Provider/Auth/auth_provider.dart';
import 'package:nirogya/Model/Dealer/dealer.dart';
import 'package:nirogya/Provider/Dealer/dealer_provider.dart';
import 'package:nirogya/Views%20&%20Controllers/Home/Page/bills.dart';
import 'package:nirogya/Views%20&%20Controllers/Home/home.dart';
import 'package:nirogya/Views%20&%20Controllers/Notification%20Screen/Notification_Screen.dart';
import 'package:nirogya/Views%20&%20Controllers/Splash%20Screen/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

//  await Hive.initFlutter();

  // Register the DealerAdapter
  Hive.registerAdapter(DealerAdapter());

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => DealerProvider()),
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
