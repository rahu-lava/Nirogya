import 'package:flutter/material.dart';
import 'package:nirogya/Auth/auth_provider.dart';
import 'package:nirogya/Screen/Home/home.dart';
// import 'package:nirogya/Screen/Home/home.dart';
import 'package:nirogya/Screen/Intro%20Screen/intro.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of the animation
    );

    _animation = Tween<double>(
      begin: 0.0, // Start with no width
      end: 1.0, // Fully revealed
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    // Navigate to the home page after the animation
    Future.delayed(const Duration(seconds: 4), () {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.logged) {
        // Navigate to HomePage if logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Navigate to IntroScreen if not logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
              ), // Clip the overflowing part
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
