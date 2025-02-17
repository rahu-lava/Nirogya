import 'package:flutter/foundation.dart';
import 'package:nirogya/Model/Dealer/dealer.dart';
import 'package:nirogya/Data/Dealer/dealer_repository.dart';

class DealerViewModel extends ChangeNotifier {
  final DealerRepository _controller = DealerRepository();
  List<Dealer> _dealers = [];
  bool _status = false;

  List<Dealer> get dealers => _dealers;
  bool get status => _status;
  bool get isEmpty => _dealers.isEmpty;

  Future<void> fetchDealers() async {
    _dealers = await _controller.getAllDealers();
    notifyListeners(); // Notify the UI to rebuild
  }

  Future<void> deleteDealer(Dealer dealer) async {
    try {
      await _controller.deleteDealer(dealer); // Use the new method
      await fetchDealers(); // Refresh the list
    } catch (e) {
      print("Error deleting dealer: $e");
    }
  }

  Future<Dealer?> getDealerByKey(dynamic key) async {
    Dealer? val = await _controller.getDealerByKey(key);
    return val;
  }

  // Method to check if a dealer with the same name already exists
  Future<bool> doesDealerExist(String dealerName) async {
    await fetchDealers(); // Ensure the list is up-to-date
    return _dealers.any((dealer) => dealer.name == dealerName);
  }

  Future<void> addDealer(Dealer dealer) async {
    try {
      // Check if a dealer with the same name already exists
      final dealerExists = await doesDealerExist(dealer.name);
      if (dealerExists) {
        _status =
            false; // Indicate that the operation failed due to a duplicate
      } else {
        await _controller.addDealer(dealer);
        _status = true; // Indicate success
      }
    } catch (e) {
      print(e);
      _status = false; // Indicate failure
    }
    await fetchDealers(); // Refresh the state after adding
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<void> clearAllDealers() async {
    try {
      await _controller.clearAllDealers();
      _status = true;
      _dealers = [];
    } catch (e) {
      _status = false;
    }
    notifyListeners();
  }
}
