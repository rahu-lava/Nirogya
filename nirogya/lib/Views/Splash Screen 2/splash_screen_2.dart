import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/home.dart';
import '../Intro Screen/intro.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of the animation
    );

    // Define the animation
    _animation = Tween<double>(
      begin: 0.0, // Start with no width
      end: 1.0, // Fully revealed
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _controller.forward();

    // Check if it's the first time and navigate accordingly
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    // Navigate after a delay to simulate a splash screen
    Future.delayed(const Duration(seconds: 3), () {
      if (isFirstTime) {
        // If it's the first time, navigate to the IntroScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroScreen()),
        );
        // Set isFirstTime to false after the first time
        prefs.setBool('isFirstTime', false);
      } else {
        // If not the first time, navigate to the HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return ClipRect(
              clipBehavior: Clip.hardEdge,
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: _animation.value, // Reveal the image gradually
                child: child,
              ),
            );
          },
          child: Image.asset(
            'assets/images/nirogya_logo_short.png', // Replace with your image path
            width: 200, // Set a fixed width for the image
            height: 200, // Set a fixed height for the image
          ),
        ),
      ),
    );
  }
}