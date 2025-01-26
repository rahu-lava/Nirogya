import 'package:flutter/foundation.dart';
import 'package:nirogya/Model/Medicine/medicine.dart';
// import 'package:nirogya/Data/MedicineQueue/medicine_queue_repository.dart';

import '../../Data/Medicine Queue/medicine_queue_repository.dart';

class PurchaseListViewModel extends ChangeNotifier {
  final MedicineQueueRepository _medicineQueueRepository = MedicineQueueRepository();
  List<Medicine> _medicineQueue = [];

  List<Medicine> get medicineQueue => _medicineQueue;

  bool get isQueueEmpty => _medicineQueue.isEmpty;

  /// Fetch all medicines from the queue
  Future<void> fetchMedicineQueue() async {
    try {
      _medicineQueue = await _medicineQueueRepository.getAllMedicinesInQueue();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching medicine queue: $e");
    }
  }

  /// Clear the current list (if needed in the UI)
  void clearMedicineQueue() {
    _medicineQueue = [];
    notifyListeners();
  }
}
