import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../Data/User/user_repository.dart';
import '../../Model/User/user.dart';
import '../../Utils/user_util.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  String? name;
  String? contact;
  String? shopName;
  String? address;
  String? gstin;
  String? profileImagePath;

  String? errorMessage;

  // Load user details from the repository
  Future<void> loadUserDetails() async {
    final user = await _userRepository.getUser();
    if (user != null) {
      name = user.name;
      contact = user.contact;
      shopName = user.shopName;
      address = user.address;
      gstin = user.gstin;
      profileImagePath = user.profileImagePath;
      notifyListeners();
    }
  }

  // Update profile image
  Future<void> updateProfileImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/user_profile_image.png';
    final savedImage = await image.copy(imagePath);
    profileImagePath = savedImage.path;

    await _userRepository.updateUser(profileImagePath: profileImagePath);
    notifyListeners();
  }

  // Validate and save user details
  Future<bool> validateAndSave() async {
    if (name == null || name!.isEmpty) {
      errorMessage = 'Name cannot be empty';
      return false;
    }
    if (contact == null || !UserUtils.isValidPhoneNumber(contact!)) {
      errorMessage = 'Invalid phone number';
      return false;
    }
    if (gstin == null || gstin!.isEmpty) {
      errorMessage = 'GSTIN cannot be empty';
      return false;
    }
    errorMessage = null;

    // Save user details to repository
    final user = User(
      name: name!,
      contact: contact!,
      shopName: shopName ?? '',
      address: address ?? '',
      gstin: gstin!,
      profileImagePath: profileImagePath,
    );
    await _userRepository.saveOrUpdateUser(user);
    notifyListeners();
    return true;
  }

  // Update specific user fields
  Future<void> updateUserFields({
    String? name,
    String? contact,
    String? shopName,
    String? address,
    String? gstin,
  }) async {
    await _userRepository.updateUser(
      name: name,
      contact: contact,
      shopName: shopName,
      address: address,
      gstin: gstin,
    );
    await loadUserDetails(); // Reload details after update
  }
}
