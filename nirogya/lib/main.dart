import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nirogya/Model/Attendence/attendance.dart';
import 'package:nirogya/Model/Bill/bill.dart';
import 'package:nirogya/Model/Employee/employee.dart';
import 'package:nirogya/Model/Final%20Medicine/final_medicine.dart';
import 'package:nirogya/Model/Sales%20Bill/sales_bill.dart';
import 'package:nirogya/Model/Scanned%20Medicine/scanned_medicine.dart';
import 'package:nirogya/Model/User/user.dart';
import 'package:nirogya/Utils/testing_utils.dart';
import 'package:nirogya/View%20Model/Add%20Purchase/add_purchase_view_model.dart';
import 'package:nirogya/View%20Model/Auth/auth_view_model.dart';
import 'package:nirogya/Model/Dealer/dealer.dart';
import 'package:nirogya/View%20Model/Dealer/dealer_view_model.dart';
import 'package:nirogya/View%20Model/Purchase%20List/purchase_list_view_model.dart';
import 'package:nirogya/View%20Model/User/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';

import 'Model/Medicine/medicine.dart';
import 'Views/Splash Screen 2/splash_screen_2.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

//  await Hive.initFlutter();

  // Register the DealerAdapter

  Hive.registerAdapter(DealerAdapter());
  Hive.registerAdapter(MedicineAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(BillAdapter());
  Hive.registerAdapter(FinalMedicineAdapter());
  Hive.registerAdapter(ScannedMedicineAdapter());
  Hive.registerAdapter(SalesBillAdapter());
  Hive.registerAdapter(EmployeeAdapter());
  Hive.registerAdapter(AttendanceAdapter());

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthViewModel()),
    ChangeNotifierProvider(create: (context) => DealerViewModel()),
    ChangeNotifierProvider(create: (context) => PurchaseViewModel()),
    ChangeNotifierProvider(create: (context) => PurchaseListViewModel()),
    ChangeNotifierProvider(create: (context) => UserViewModel()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TestingUtils.printAllBills();
    TestingUtils.printAllMedicinesInQueue();
    try {
      TestingUtils.printAllFinalMedicines();
    } catch (e) {
      ToastService.showErrorToast(context,
          length: ToastLength.medium,
          message: "Failed to fetch final Medicine");
    }
    TestingUtils.printAllHistory();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Poppins"),
      home: const SplashScreen2(),
    );
  }
}
