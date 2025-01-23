import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../Model/Medicine/medicine.dart';

class MedicineQueueController with ChangeNotifier {
  late Box<Medicine> _medicineQueueBox;
  List<Medicine> _medicineQueue = [];
  List<Medicine> _pendingMedicineQueue = []; // New list for pending medicines

  /// Getter for the list of medicines in the queue
  List<Medicine> get medicineQueue => _medicineQueue;

  /// Getter for the pending medicines
  List<Medicine> get pendingMedicineQueue => _pendingMedicineQueue;

  /// Initialize the controller and load medicines into the queue
  Future<void> initialize() async {
    _medicineQueueBox = await Hive.openBox<Medicine>('medicineQueue');
    _loadMedicineQueue();
  }

  /// Load medicines from the Hive box into the queue
  void _loadMedicineQueue() {
    _medicineQueue = _medicineQueueBox.values.toList();
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Add a new medicine to the pending queue
  void addMedicineToPendingQueue(Medicine medicine) {
    _pendingMedicineQueue.add(medicine);
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Remove a medicine from the pending queue by index
  void removeMedicineFromPendingQueue(int index) {
    if (index >= 0 && index < _pendingMedicineQueue.length) {
      _pendingMedicineQueue.removeAt(index);
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  /// Update a medicine in the pending queue at a specific index
  void updateMedicineInPendingQueue(int index, Medicine updatedMedicine) {
    if (index >= 0 && index < _pendingMedicineQueue.length) {
      _pendingMedicineQueue[index] = updatedMedicine;
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  /// Confirm adding the pending medicines to the main queue
  Future<void> confirmMedicineQueue() async {
    for (var medicine in _pendingMedicineQueue) {
      await _medicineQueueBox.add(medicine);
    }
    _pendingMedicineQueue.clear(); // Clear the pending queue after confirmation
    _loadMedicineQueue();
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Clear all medicines from the main queue (e.g., after processing)
  Future<void> clearMedicineQueue() async {
    await _medicineQueueBox.clear();
    _loadMedicineQueue();
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Clear all medicines from the pending queue
  void clearPendingQueue() {
    _pendingMedicineQueue.clear(); // Clears the pending queue
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Get a medicine from the queue by index
  Medicine? getMedicineFromQueue(int index) {
    if (index >= 0 && index < _medicineQueue.length) {
      return _medicineQueue[index];
    }
    return null; // Return null if index is out of bounds
  }

  /// Check if the queue is empty
  bool isQueueEmpty() {
    return _medicineQueue.isEmpty;
  }

  /// Check if the pending queue is empty
  bool isPendingQueueEmpty() {
    return _pendingMedicineQueue.isEmpty;
  }
}
