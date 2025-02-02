import 'package:hive/hive.dart';
import '../../Model/User/user.dart';

class UserRepository {
  static const String _userBoxName = 'userBox';
  static const String _userKey = 'currentUser';

  // Open the Hive box
  Future<Box<User>> _getUserBox() async {
    return await Hive.openBox<User>(_userBoxName);
  }

  // Save or Update User
  Future<void> saveOrUpdateUser(User user) async {
    final box = await _getUserBox();
    await box.put(_userKey, user);
  }

  // Get the User
  Future<User?> getUser() async {
    final box = await _getUserBox();
    return box.get(_userKey);
  }

  // Update specific fields of the User
  Future<void> updateUser(
      {String? name,
      String? contact,
      String? shopName,
      String? address,
      String? gstin,
      String? profileImagePath}) async {
    final box = await _getUserBox();
    final currentUser = box.get(_userKey);

    if (currentUser != null) {
      currentUser
        ..name = name ?? currentUser.name
        ..contact = contact ?? currentUser.contact
        ..shopName = shopName ?? currentUser.shopName
        ..address = address ?? currentUser.address
        ..gstin = gstin ?? currentUser.gstin
        ..profileImagePath = profileImagePath ?? currentUser.profileImagePath;

      await currentUser.save(); // Save the updated user
    }
  }
}
