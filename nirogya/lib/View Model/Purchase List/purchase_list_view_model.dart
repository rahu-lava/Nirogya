import 'package:flutter/foundation.dart';
import 'package:nirogya/Model/Medicine/medicine.dart';
import 'package:nirogya/Utils/testing_utils.dart';
import 'package:nirogya/View%20Model/Add%20Purchase/add_purchase_view_model.dart';

class PurchaseListViewModel extends ChangeNotifier {
  // final MedicineQueueRepository _medicineQueueRepository =
  //     MedicineQueueRepository();
  PurchaseViewModel purchaseViewModel = PurchaseViewModel();
  List<Medicine> _tempMedicineQueue = [];

  List<Medicine> get tempMedicineQueue => _tempMedicineQueue;

  bool get isTempQueueEmpty => _tempMedicineQueue.isEmpty;

  /// Fetch all medicines from the queue
  Future<void> fetchMedicineQueue() async {
    print("fetching queue");
    try {
      _tempMedicineQueue = PurchaseViewModel.tempMedicines;
      TestingUtils.printAllMedicines(_tempMedicineQueue);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching medicine queue: $e");
    }
    notifyListeners();
  }

  /// Clear the current list (if needed in the UI)
  void clearMedicineQueue() {
    _tempMedicineQueue = [];
    notifyListeners();
  }
}
