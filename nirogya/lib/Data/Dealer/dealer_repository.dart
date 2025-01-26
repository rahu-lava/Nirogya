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
    var dealer = box.get(1);
    print(dealer?.name);
    return box.get(key);
  }

  Future<void> updateDealer(dynamic key, Dealer updatedDealer) async {
    final box = await _openBox();
    await box.put(key, updatedDealer);
  }

  Future<void> deleteDealer(dynamic key) async {
    final box = await _openBox();
    await box.delete(key);
  }

  Future<void> clearAllDealers() async {
    final box = await _openBox();
    await box.clear();
  }
}
