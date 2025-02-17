import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nirogya/Data/Scanned%20Medicine/scanned_medicine_repo.dart';
import 'package:nirogya/Utils/testing_utils.dart';
import 'package:nirogya/View%20Model/Add%20Purchase/add_purchase_view_model.dart';
import 'package:provider/provider.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';
import '../../../Data/Bill/bill_repository.dart';
import '../../../Data/Sales Bill/sales_bill_repo.dart';
import '../../../Model/Dealer/dealer.dart';
import '../../../View Model/Dealer/dealer_view_model.dart';
import '../../../Widget/Sales_list.dart';
import '../../../Widget/bills_card.dart';
import '../../../Widget/purchase_list.dart';
import '../../Add Dealer Screen/add_dealer.dart';
import '../../AddProductBills/add_product_bills.dart';
import '../../Barcode Scanner Bills/barcode_scanner_bills.dart';
import '../../Add Purchase Screen/purchase_bill_add_product.dart';

class Bills extends StatefulWidget {
  const Bills({super.key});

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  late DealerViewModel dealerProvider;
  String? selectedDealer;
  double totalSalesToday = 0.0;
  double totalPurchasesThisWeek = 0.0;

  Future<void> _initializeDealers() async {
    dealerProvider = context.read<DealerViewModel>();
    try {
      await dealerProvider.fetchDealers();
    } catch (e) {
      print("Error fetching dealers: $e");
    }
  }

  static Future<double> getTotalSalesForToday() async {
    final salesBills = await SalesBillRepository.getAllSalesBills();
    final now = DateTime.now();
    final todaySales = salesBills.where((bill) {
      final billDate = DateTime.parse(bill.date.toString());
      return billDate.year == now.year &&
          billDate.month == now.month &&
          billDate.day == now.day;
    }).toList();

    double totalAmount = todaySales.fold(0.0, (sum, bill) {
      return sum +
          bill.medicines.fold(0.0,
              (sum, medicine) => sum + (medicine.price * medicine.quantity));
    });
    print("rahulava :" + totalAmount.toString());

    return totalAmount;
  }

  static Future<double> getTotalPurchasesForWeek() async {
    final bills = await BillRepository.getAllBills();
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    final weeklyBills = bills.where((bill) {
      final billDate = DateTime.parse(bill.date.toString());
      return billDate.isAfter(startOfWeek) && billDate.isBefore(endOfWeek);
    }).toList();

    double totalAmount = weeklyBills.fold(0.0, (sum, bill) {
      return sum +
          bill.medicines.fold(0.0,
              (sum, medicine) => sum + (medicine.price * medicine.quantity));
    });
    print("rahulava" + totalAmount.toString());
    return totalAmount;
  }

  Future<void> _fetchSalesAndPurchases() async {
    totalSalesToday = await getTotalSalesForToday();
    totalPurchasesThisWeek = await getTotalPurchasesForWeek();
    if(mounted){
   setState(() {});
    }
 
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _initializeDealers();
      _fetchSalesAndPurchases();
    }
    // fetchDealer(context);
  }

  @override
  Widget build(BuildContext context) {
    TestingUtils.printAllAddedMedicines();
    TestingUtils.printAllSalesBills();
    ScannedMedicineRepository().printAllScannedMedicines();

    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BillsCard(
                title: "Sales \nToday",
                amount: "${((totalSalesToday / 1000)).toStringAsFixed(1)}k"),
            BillsCard(
                title: "Purchase \nThis week",
                amount:
                    "${(totalPurchasesThisWeek / 1000).toStringAsFixed(1)}k"),
          ],
        ),
        const SizedBox(height: 20),
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
                  _showDailog();
                },
                child: const Text(
                  "Customer Bill",
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
                onPressed: () {
                  _showDealerDialog(context);
                },
                child: const Text(
                  "Purchase Bill",
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
        const SizedBox(height: 20),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  indicatorColor: Color(0xff920000),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 4,
                  labelColor: Color.fromARGB(255, 128, 0, 0),
                  unselectedLabelColor: Colors.grey,
                  labelStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      child: Text(
                        "Recent Sales",
                        style: TextStyle(
                            fontFamily: "Poppins", fontWeight: FontWeight.w500),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Recent Purchase",
                        style: TextStyle(
                            fontFamily: "Poppins", fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    children: [
                      Center(
                        child: SalesList(),
                      ),
                      Center(child: PurchaseList()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDailog() {
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
                const Text(
                  "Select Option",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BarcodeScannerWithList(),
                          ),
                        );
                      },
                      child: Container(
                        width: 120, // Fixed width for both containers
                        padding: const EdgeInsets.all(10),
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
                            const SizedBox(height: 10),
                            const Text(
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
                              builder: (context) => const AddProductBills()),
                        );
                      },
                      child: Container(
                        width: 120, // Fixed width for both containers
                        padding: const EdgeInsets.all(10),
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
                            const SizedBox(height: 10),
                            const Text(
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
      },
    );
  }

  void _showDealerDialog(BuildContext context) {
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
                const Text(
                  "Select Dealer",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                ),
                const SizedBox(height: 20),
                _buildDealerDropdown(context),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        print(selectedDealer);
                        if (selectedDealer != "Add New Dealer" &&
                            selectedDealer != "") {
                          PurchaseViewModel.setCurrentDealer(
                              currentDealer: selectedDealer!);
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PurchaseBillPage(),
                            ),
                          );
                        } else {
                          ToastService.showWarningToast(context,
                              message: "Select Dealer First",
                              length: ToastLength.medium);
                        }
                      },
                      child: const Text(
                        "Proceed",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDealerDropdown(BuildContext context) {
    final dealerProvider = Provider.of<DealerViewModel>(context);
    List<Dealer> dealers = dealerProvider.dealers;
    Dealer dealerAdd = Dealer(
        name: "Add New Dealer",
        contactNumber: "1234567890",
        gstin: "gstin",
        hasWhatsApp: false);
    List<Dealer> dealer = [dealerAdd];

    dealers += dealer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label for the dropdown
        const Text.rich(
          TextSpan(
            text: "Dealer Name",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5), // Space between label and dropdown

        // Dropdown field
        DropdownButtonFormField<String>(
          value: selectedDealer,
          decoration: InputDecoration(
            hintText: "Select Dealer",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red.shade200, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
          ),
          items: dealers.map((dealer) {
            return DropdownMenuItem<String>(
              value: dealer.name,
              child: Text(dealer.name),
            );
          }).toList(),
          onChanged: (value) {
            if (value == "Add New Dealer") {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const AddDealerScreen()),
              );
            } else {
              setState(() {
                print(value);
                selectedDealer = value;
              });
            }
          },
        ),
      ],
    );
  }
}
