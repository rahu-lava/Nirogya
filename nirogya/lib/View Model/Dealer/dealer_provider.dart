import 'package:flutter/foundation.dart';
import 'package:nirogya/Model/Dealer/dealer.dart';
import 'package:nirogya/Data/Dealer/dealer_controller.dart';

class DealerProvider extends ChangeNotifier {
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
  
  Future<Dealer?> getDealerByKey(dynamic key) async {
    Dealer? val =   await _controller.getDealerByKey(key);
    return val;
    // return _dealers[key];
  }

  Future<void> addDealer(Dealer dealer) async {
    try {
      await _controller.addDealer(dealer);
      _status = true;
    } catch (e) {
      print(e);
      _status = false;
    }
    await fetchDealers(); // Refresh the state after adding
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
