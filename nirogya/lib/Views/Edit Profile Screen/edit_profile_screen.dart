import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nirogya/Model/User/user.dart';
import 'package:nirogya/Data/User/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserRepository _userRepository = UserRepository();

  XFile? _profileImage; // Variable to store the picked image
  User? _user; // To store user data

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _gstinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  // Load user details from the repository
  Future<void> _loadUserDetails() async {
    final user = await _userRepository.getUser();
    if (user != null) {
      setState(() {
        _user = user;
        _nameController.text = user.name;
        _contactController.text = user.contact;
        _shopNameController.text = user.shopName;
        _addressController.text = user.address;
        _gstinController.text = user.gstin;
        if (user.profileImagePath != null) {
          _profileImage = XFile(user.profileImagePath!);
        }
      });
    }
  }

  // Function to pick image from gallery or camera
  Future<void> _pickImage() async {
    if (kIsWeb) {
      // debugPrint("hey clicked");
      ToastService.showWarningToast(context,
          length: ToastLength.medium,
          message: "Use mobile app to upload images");
      return;
    }

    final picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source:
            ImageSource.gallery, // You can change this to ImageSource.camera
      );
      if (pickedFile != null) {
        setState(() {
          _profileImage = pickedFile;
        });
      }
    } on Exception catch (e) {
      // TODO
      ToastService.showErrorToast(context,
          length: ToastLength.medium, message: "Failed to pick image");
    }
  }

  // Save updated user details
  Future<void> _saveUserDetails() async {
    if (_nameController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _shopNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _gstinController.text.isEmpty) {
      ToastService.showErrorToast(context,
          message: 'Please fill all fields', length: ToastLength.medium);

      return;
    }

    final updatedUser = User(
      name: _nameController.text,
      contact: _contactController.text,
      shopName: _shopNameController.text,
      address: _addressController.text,
      gstin: _gstinController.text,
      profileImagePath: _profileImage?.path,
    );

    await _userRepository.saveOrUpdateUser(updatedUser).then((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isProfileSet', true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            bool? profileStatus =
                prefs.getBool('isProfileSet'); // Get the 'isProfileSet' flag

            if (profileStatus == null || !profileStatus) {
              // If profile is not set, navigate to profile setup screen
              ToastService.showWarningToast(context,
                  length: ToastLength.medium,
                  message: "Please set the profile details");
              return;
            }
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          // Profile Image with hover effect and editing functionality
          Center(
            child: Stack(
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
                    image: _profileImage == null
                        ? const DecorationImage(
                            image:
                                AssetImage('assets/images/profile_picture.png'),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: FileImage(File(_profileImage!.path)),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () =>
                        {_pickImage()}, // Allow image picking or capturing
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Scrollable input fields container
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input fields with small labels
                  ProfileInputField(
                    label: 'Name',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 15),
                  ProfileInputField(
                    label: 'Contact',
                    controller: _contactController,
                    inputType: TextInputType.phone,
                  ),
                  const SizedBox(height: 15),
                  ProfileInputField(
                    label: 'Shop Name',
                    controller: _shopNameController,
                    inputType: TextInputType
                        .text, // GSTIN can have letters and numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]'))
                    ], // Allow only alphanumeric input
                  ),
                  const SizedBox(height: 15),
                  ProfileInputField(
                    label: 'Address',
                    controller: _addressController,
                  ),
                  const SizedBox(height: 15),
                  ProfileInputField(
                    label: 'GSTIN Number',
                    controller: _gstinController,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Fixed Save Button at the bottom
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: ElevatedButton(
                onPressed: _saveUserDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff920000),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatters;

  const ProfileInputField({
    super.key,
    required this.label,
    required this.controller,
    this.inputType = TextInputType.text, // Default to text input
    this.inputFormatters, // Optional input formatters
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: inputType, // Set the keyboard type based on the field
          inputFormatters: inputFormatters, // Add the input formatters
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF920000), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF920000), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF920000), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
