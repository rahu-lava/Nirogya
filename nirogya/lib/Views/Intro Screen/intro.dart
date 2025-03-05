import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nirogya/View%20Model/Auth/auth_view_model.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Home/home.dart';
import '../Login Screen/login.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:nirogya/Screen/Home/home.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  // AuthProvider authProvider =
  int _currentIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    print(
        'Current Index: $_currentIndex'); // Print the current index whenever the page is changed
  }

  void _onNextButtonPressed() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Handle "Get Started" button action here
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
      print("Get Started Pressed");
    }
  }

  Widget _buildCircularButton() {
    return GestureDetector(
      onTap: _onNextButtonPressed,
      child: Container(
        key: const ValueKey("circleButton"),
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          color: Color(0xFF920000),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      key: const ValueKey("textButton"),
      width: 280,
      height: 45,
      child: TextButton(
        onPressed: _onNextButtonPressed,
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFF920000),
          // padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          "Get Started",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

// List of pages for the intro
  final List<Map<String, String>> _pages = [
    {
      'title1': 'Simplify',
      'title2': 'Management',
      'body':
          'Manage stock, generate bills, and track attendance effortlessly with Nirogya streamline your pharmacy operations in one place.',
      'image': 'assets/images/IntroScreen-1.svg',
    },
    {
      'title1': 'Visulize',
      'title2': 'Your Data',
      'body':
          'Analyze sales, monitor inventory, and track performance with clear, eye-catching graphics to make smarter decisions.',
      'image': 'assets/images/IntroScreen-2.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // updateIsFirst();
    AuthViewModel authProvider = context.read<AuthViewModel>();
    authProvider.setFirstTime();

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 650,
                // height: MediaQuery.of(context).size.height * 0.75 > 600
                //     ? 600
                //     : MediaQuery.of(context).size.height * 0.75,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return IntroPage(
                      title1: page['title1']!,
                      title2: page['title2']!,
                      desc: page['body']!,
                      image: page['image']!,
                    );
                  },
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      height: 12.0,
                      width: 12.0,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? const Color(
                                0xFF920000) // Active Circle Color (Dark Red)
                            : const Color(
                                0xFFFFB8B8), // Inactive Circle Color (Lighter Red)
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _currentIndex < _pages.length - 1
                      ? Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: _buildCircularButton(),
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: _buildGetStartedButton(),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  final String title1;
  final String title2;
  final String desc;
  final String image;

  const IntroPage(
      {required this.title1,
      required this.title2,
      required this.desc,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 75),
      child: Column(
        children: [
          SvgPicture.asset(
            image,
            height: MediaQuery.of(context).size.height * 0.35 > 220
                ? 250
                : MediaQuery.of(context).size.height * 0.35,
          ),
          const SizedBox(height: 50.0),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title1,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 32.0,
                        // letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 146, 0, 0)),
                  ),
                  Text(
                    title2,
                    style: const TextStyle(
                        fontSize: 32.0,
                        // letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 146, 0, 0)),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    desc,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 18.0,
                        color: Color(0xff393939),
                        fontWeight: FontWeight.w300,
                        fontFamily: "Poppins"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
