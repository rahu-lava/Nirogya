import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nirogya/Views/About%20us%20Screen/about_us_screen.dart';
import 'package:nirogya/Views/Attendence%20Screen/attendence_screen.dart';
import 'package:nirogya/Views/Download%20Screen/download_screen.dart';
import 'package:nirogya/Views/Edit%20Profile%20Screen/edit_profile_screen.dart';
import 'package:nirogya/Widget/staff_list.dart';
import 'package:nirogya/Views/Settings%20Screen/settings_screen.dart';
import 'package:nirogya/Views/Subscription%20Screen/subscription_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
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
                    image: const DecorationImage(
                      image: AssetImage('assets/images/profile_picture.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Rahul Yadav',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const Text(
                  'GSTIN: 27XXXXX1234XX1Z5',
                  style: TextStyle(
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
                  child: _buildOption("assets/images/Profile.png", 'Profile')),
              const SizedBox(height: 10),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AttendanceScreen()));
                  },
                  child: _buildOption(
                      "assets/images/Attendance.png", 'Attendance')),
              const SizedBox(height: 10),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DownloadScreen()));
                  },
                  child:
                      _buildOption("assets/images/Downloads.png", 'Download')),
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
                      builder: (context) => PremiumSubscriptionScreen()));
                },
                child: _buildOption("assets/images/Star.png", 'Premium',
                    textColor: Colors.amber),
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
