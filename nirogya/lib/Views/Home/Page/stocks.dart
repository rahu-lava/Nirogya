import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:nirogya/Views/Add%20Stock%20Scanner/scanner_add_stock.dart';
import 'package:nirogya/Views/Added%20Product%20Screen/added_product_list.dart';
import 'package:nirogya/Views/Dealers%20List%20screen/dealers_list.dart';
import 'package:nirogya/Widget/search_widget.dart';
import 'package:nirogya/Widget/stocks_card.dart';

import '../../../Data/Added Medicine/added_medicine_repo.dart';

class Stocks extends StatefulWidget {
  const Stocks({super.key});

  @override
  State<Stocks> createState() => _StocksState();
}

class _StocksState extends State<Stocks> {
  int expiredCount = 0;
  int soonExpiringCount = 0; // New variable for soon expiring medicines
  int lowStockCount = 0;

  Future<void> _fetchMedicineData() async {
    final addedMedicineRepo = AddedMedicineRepository();
    final addedMedicines = await addedMedicineRepo.getAllAddedMedicines();

    final now = DateTime.now();
    final soonExpiryThreshold =
        now.add(Duration(days: 30)); // 30 days for soon expiring
    DateFormat format = DateFormat("dd/MM/yyyy");

    // Calculate expired medicines
    expiredCount = addedMedicines.where((medicine) {
      try {
        DateTime expiryDate =
            format.parse(medicine.finalMedicine.medicine.expiryDate);
        return expiryDate.isBefore(now);
      } catch (e) {
        print(
            "Error parsing date: ${medicine.finalMedicine.medicine.expiryDate}");
        return false; // Skip invalid dates
      }
    }).length;

    // Calculate soon expiring medicines (excluding expired medicines)
    soonExpiringCount = addedMedicines.where((medicine) {
      try {
        DateTime expiryDate =
            format.parse(medicine.finalMedicine.medicine.expiryDate);
        return expiryDate.isAfter(now) &&
            expiryDate.isBefore(soonExpiryThreshold);
      } catch (e) {
        print(
            "Error parsing date: ${medicine.finalMedicine.medicine.expiryDate}");
        return false; // Skip invalid dates
      }
    }).length;

    // Calculate low stock medicines
    lowStockCount = addedMedicines.where((medicine) {
      return medicine.finalMedicine.medicine.quantity < 5;
    }).length;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _fetchMedicineData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StocksCard(
                title: "Expired", amount: "$expiredCount", isYellow: false),
            StocksCard(
                title: "Soon Expiry",
                amount: "$soonExpiringCount",
                isYellow: true),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xff920000),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ScannerAddStock(),
                    ),
                  );
                },
                child: const Text(
                  "Add Stocks",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xff920000),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderStockPage()));
                },
                child: Text(
                  "Order Stock",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Expanded(child: SearchStockWidget()),
      ],
    );
  }

  void ShowDailog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Select Option",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ScannerAddStock(),
                            ),
                          );
                        },
                        child: Container(
                          width: 120, // Fixed width for both containers
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xff920000),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/scanner_icon.png',
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Scanner",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          // Add logic for "Manually" option here
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ProductList()),
                          );
                        },
                        child: Container(
                          width: 120, // Fixed width for both containers
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xff920000),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/Keyboard.png',
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Manually",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
