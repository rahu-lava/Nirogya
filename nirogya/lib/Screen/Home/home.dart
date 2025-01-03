import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:nirogya/Screen/Home/Page/bills.dart';
import 'package:nirogya/Screen/Home/Page/dashboard.dart';
import 'package:nirogya/Screen/Home/Page/stocks.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController NavController = PageController();
  var _selectedIndex = 0;
  double _buttonOffset = 7.0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 4,
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
                    print("Notification icon tapped");
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
                      child: Stocks(),
                    ),
                    const Center(
                      child: Text("hey"),
                    ),
                    const Center(
                      child: Text('Third Page'),
                    ),
                    const Center(
                      child: Text('Fourth Page'),
                    ),
                  ],
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  bottom: _buttonOffset,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      print("Custom floating button tapped");
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
                  color: _selectedIndex == 0
                      ? const Color(0xff920000)
                      : Colors.grey,
                  height: 30,
                  width: 30,
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/Payment_Check.png',
                  color: _selectedIndex == 1
                      ? const Color(0xff920000)
                      : Colors.grey,
                  height: 30,
                  width: 30,
                ),
                label: 'Bills',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/Box.png',
                  color: _selectedIndex == 2
                      ? const Color(0xff920000)
                      : Colors.grey,
                  height: 30,
                  width: 30,
                ),
                label: 'Stocks',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/User.png',
                  color: _selectedIndex == 3
                      ? const Color(0xff920000)
                      : Colors.grey,
                  height: 30,
                  width: 30,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
