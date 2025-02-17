import 'package:hive/hive.dart';
import '../../Model/Dealer/dealer.dart';

class DealerRepository {
  final String _boxName = 'dealers';

  Future<Box<Dealer>> _openBox() async {
    return await Hive.openBox<Dealer>(_boxName);
  }

  Future<void> addDealer(Dealer dealer) async {
    final box = await _openBox();
    await box.add(dealer);
  }

  Future<List<Dealer>> getAllDealers() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<Dealer?> getDealerByKey(dynamic key) async {
    final box = await _openBox();
    return box.get(key);
  }

  Future<void> updateDealer(dynamic key, Dealer updatedDealer) async {
    final box = await _openBox();
    await box.put(key, updatedDealer);
  }

  Future<void> deleteDealerByKey(dynamic key) async {
    final box = await _openBox();
    await box.delete(key);
  }

  Future<void> deleteDealer(Dealer dealer) async {
    final box = await _openBox();
    final dealerKey = _findDealerKey(box, dealer);
    if (dealerKey != null) {
      await box.delete(dealerKey);
    } else {
      throw Exception("Dealer not found in the database");
    }
  }

  Future<void> clearAllDealers() async {
    final box = await _openBox();
    await box.clear();
  }

  // Helper method to find the key of a dealer in the box
  dynamic _findDealerKey(Box<Dealer> box, Dealer dealer) {
    for (var key in box.keys) {
      final currentDealer = box.get(key);
      if (currentDealer == dealer) {
        return key;
      }
    }
    return null;
  }
}