import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nirogya/Views/About%20us%20Screen/about_us_screen.dart';
import 'package:nirogya/Views/Attendence%20Screen/attendence_screen.dart';
import 'package:nirogya/Views/Download%20Screen/download_screen.dart';
import 'package:nirogya/Views/Edit%20Profile%20Screen/edit_profile_screen.dart';
import 'package:nirogya/Views/Medicine%20Queue%20Screen/medicine_queue_screen.dart';
import 'package:nirogya/Widget/staff_list.dart';
import 'package:nirogya/Views/Settings%20Screen/settings_screen.dart';
import 'package:nirogya/Views/Subscription%20Screen/subscription_screen.dart';
import 'package:nirogya/Data/User/user_repository.dart'; // Import the UserRepository
import 'package:nirogya/Model/User/user.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import '../../../Utils/testing_utils.dart'; // Import the User model

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserRepository _userRepository = UserRepository();
  User? _user; // To store user data
  bool _isSubscribed = false; // Subscription status

  @override
  void initState() {
    super.initState();
    _loadUserDetails(); // Load user details when the widget initializes
    _checkSubscriptionStatus(); // Check subscription status
  }

  // Load user details from the repository
  Future<void> _loadUserDetails() async {
    await TestingUtils.printAllEmployees();

    final user = await _userRepository.getUser();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  // Check subscription status from SharedPreferences
  Future<void> _checkSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSubscribed = prefs.getBool('isSubscribed') ?? false;
    });
  }

  // Navigate to a screen if subscribed, else show a Snackbar
  void _navigateIfSubscribed(Widget screen) {
    if (_isSubscribed) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => screen));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You need a subscription to access this feature.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                // Profile Image
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xff920000),
                      width: 3,
                    ),
                    shape: BoxShape.circle,
                    image: _user?.profileImagePath != null
                        ? DecorationImage(
                            image: FileImage(File(_user!.profileImagePath!)),
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            image:
                                AssetImage('assets/images/profile_picture.png'),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                // User Name
                Text(
                  _user?.name ??
                      'Rahul Yadav', // Default name if user data is null
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                // GSTIN Number
                Text(
                  _user?.gstin ??
                      'GSTIN: 27XXXXX1234XX1Z5', // Default GSTIN if user data is null
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditProfileScreen()));
                  },
                  child: _buildOption(
                      "assets/images/Profile.png", 'Edit Profile')),
              const SizedBox(height: 10),
              GestureDetector(
                  onTap: () {
                    _navigateIfSubscribed(AttendanceScreen());
                  },
                  child: _buildOptionWithStar(
                      "assets/images/Attendance.png", 'Attendance')),
              const SizedBox(height: 10),
              GestureDetector(
                  onTap: () {
                    _navigateIfSubscribed(DownloadScreen());
                  },
                  child: _buildOptionWithStar(
                      "assets/images/Downloads.png", 'Download')),
              const SizedBox(height: 10),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MedicineQueueScreen()));
                  },
                  child:
                      _buildOption("assets/icons/Box.png", 'Medicine Queue')),
              const SizedBox(height: 10),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsScreen()));
                  },
                  child:
                      _buildOption("assets/images/Settings.png", 'Settings')),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SubscriptionScreen()));
                },
                child: _buildOption("assets/images/Star.png", 'Premium',
                    textColor: Color(0xFFD4AF37)),
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Color(0xff920000),
                indent: 135,
                endIndent: 135,
                thickness: 1.5,
              ),
              const SizedBox(height: 5),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AboutUsScreen()));
                  },
                  child: _buildOption("assets/images/About.png", "About Us")),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Rahul Yadav | Nirogya',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Build an option with a gold star at the trail (end side)
  Widget _buildOptionWithStar(String path, String text,
      {Color textColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Image.asset(path),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: textColor,
              ),
            ),
          ),
          Icon(
            Icons.star,
            color: Color(0xFFD4AF37), // Gold star
          ),
        ],
      ),
    );
  }

  // Build a regular option
  Widget _buildOption(String path, String text,
      {Color textColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Image.asset(path),
          const SizedBox(width: 20),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
