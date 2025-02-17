import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:nirogya/Data/Scanned%20Medicine/scanned_medicine_repo.dart';
import 'package:nirogya/Model/Dealer/dealer.dart';
import 'package:nirogya/Utils/testing_utils.dart';
import 'package:nirogya/Views/Add%20Stock%20Scanner/scanner_add_stock.dart';
import 'package:nirogya/Views/Barcode%20Scanner%20Bills/barcode_scanner_bills.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';
import '../../View Model/Dealer/dealer_view_model.dart';
import '../Edit Profile Screen/edit_profile_screen.dart';
import '../Notification Screen/Notification_Screen.dart';
import 'Page/bills.dart';
import 'Page/dashboard.dart';
import 'Page/profile.dart';
import 'Page/stocks.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController NavController = PageController();
  late int _selectedIndex;
  double _buttonOffset = 7.0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Set the initial index
    _checkProfileStatus(); // Check if profile is set

    WidgetsBinding.instance.addPostFrameCallback((_) {
      NavController.jumpToPage(_selectedIndex);
    });
  }

  Future<void> _checkProfileStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? profileStatus =
        prefs.getBool('isProfileSet'); // Get the 'isProfileSet' flag

    if (profileStatus == null || !profileStatus) {
      // If profile is not set, navigate to profile setup screen
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const EditProfileScreen(), // Create this screen
      ));

      ToastService.showWarningToast(context,
          length: ToastLength.medium,
          message: "Set Profile Details To Proceed");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Animate to the selected page
    NavController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          leading: null,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Image.asset(
              "assets/images/nirogya_logo_short.png",
              height: 100,
              width: 100,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: IconButton(
                icon: const Icon(
                  color: Color(0xff920000),
                  Icons.notifications_none,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NotificationScreen()));
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              PageView(
                controller: NavController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex =
                        index; // Update the selected index when the page changes
                  });
                },
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is UserScrollNotification) {
                        setState(() {
                          if (scrollNotification.direction ==
                              ScrollDirection.reverse) {
                            _buttonOffset = -60.0; // Hide button
                          } else if (scrollNotification.direction ==
                              ScrollDirection.forward) {
                            _buttonOffset = 7.0; // Show button
                          }
                        });
                      }
                      return true;
                    },
                    child: SingleChildScrollView(child: Dashboard()),
                  ),
                  const Center(
                    child: Bills(),
                  ),
                  const Center(
                    child: Stocks(),
                  ),
                  Profile(),
                ],
              ),
              // Hide the floating button when on Bills or Stocks page
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                bottom: (_selectedIndex == 1 || _selectedIndex == 2)
                    ? -60.0 // Hide the button on Bills or Stocks page
                    : _buttonOffset,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BarcodeScannerWithList()));
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xff920000),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Lottie.asset(
                      'assets/animation/scan_anim.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xff920000),
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/Bar_Chart.png',
                color:
                    _selectedIndex == 0 ? const Color(0xff920000) : Colors.grey,
                height: 30,
                width: 30,
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/Payment_Check.png',
                color:
                    _selectedIndex == 1 ? const Color(0xff920000) : Colors.grey,
                height: 30,
                width: 30,
              ),
              label: 'Bills',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/Box.png',
                color:
                    _selectedIndex == 2 ? const Color(0xff920000) : Colors.grey,
                height: 30,
                width: 30,
              ),
              label: 'Stocks',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/User.png',
                color:
                    _selectedIndex == 3 ? const Color(0xff920000) : Colors.grey,
                height: 30,
                width: 30,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
