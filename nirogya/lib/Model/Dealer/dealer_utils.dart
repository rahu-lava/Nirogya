import 'dealer.dart';

class DealerUtils {
  // Format GSTIN for display
  static String formatGSTIN(String gstin) {
    return gstin.toUpperCase();
  }

  // Check if a contact number is valid
  static bool isValidContactNumber(String contactNumber) {
    final regex = RegExp(r'^[6-9]\d{9}$'); // Indian mobile numbers
    return regex.hasMatch(contactNumber);
  }

  // Filter dealers with WhatsApp numbers
  static List<Dealer> filterDealersWithWhatsApp(List<Dealer> dealers) {
    return dealers.where((dealer) => dealer.hasWhatsApp).toList();
  }

  // Format dealer details for display
  static String formatDealerDetails(Dealer dealer) {
    return '''
Name: ${dealer.name}
Contact: ${dealer.contactNumber}
GSTIN: ${formatGSTIN(dealer.gstin)}
WhatsApp: ${dealer.hasWhatsApp ? 'Yes' : 'No'}
''';
  }
}
