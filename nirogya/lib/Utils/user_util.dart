class UserUtils {
  /// Validates if the given email is in a proper format
  static bool isValidEmail(String email) {
    // Regular expression for email validation
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  /// Validates if the given phone number is valid (basic example)
  static bool isValidPhoneNumber(String phoneNumber) {
    // Assumes phone number is 10 digits and numeric
    final phoneRegex = RegExp(r"^\d{10}$");
    return phoneRegex.hasMatch(phoneNumber);
  }
}
