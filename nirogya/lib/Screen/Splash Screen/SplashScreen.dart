import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:nirogya/Auth/auth_provider.dart';
import 'package:nirogya/Screen/Home/home.dart';
import 'package:nirogya/Screen/Intro%20Screen/intro.dart';
import 'package:nirogya/Screen/Login%20Screen/login.dart';
import 'package:nirogya/Screen/SetNameScreen/set_name.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    late bool isLogged;
    late bool isFirstTime;
    _controller.forward();

    // Navigate to the home page after the animation
    Future.delayed(const Duration(seconds: 3), () async {

      isLogged = authProvider.logged;
      isFirstTime = authProvider.isFirstTime;
      print("Logged in : " + isLogged.toString());
      print("First Time : " + isFirstTime.toString());

      if (isLogged) {
        // If logged in, check the user info
        Client client = authProvider.client;
        Account account = Account(client);

        try {
          final user = await account.get(); // Fetch user data
          print("The user is : " + user.name.toString());

          if (user.name.length == 0) {
            // If user data is empty, navigate to the IntroScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SetName()),
            );
          } else {
            // Navigate to the HomePage if user data is available
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        } catch (e) {
          // If account.get() fails (e.g., user is not logged in), navigate to IntroScreen
          if (isFirstTime) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const IntroScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        }
      } else {
        // If not logged in, navigate to IntroScreen
        if (isFirstTime) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const IntroScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
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
