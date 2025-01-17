import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../Widget/Sales_list.dart';
import '../../../Widget/bills_card.dart';
import '../../../Widget/purchase_list.dart';
import '../../AddProductBills/add_product_bills.dart';
import '../../Barcode Scanner Bills/barcode_scanner_bills.dart';
import '../../PurchaseBillPage/purchase_bill_add_product.dart';

class Bills extends StatefulWidget {
  const Bills({super.key});

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BillsCard(title: "Sales \nToday", amount: "2k"),
            BillsCard(title: "Pending \nPayments", amount: "1.2k"),
          ],
        ),
        SizedBox(height: 20),
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
                child: Text(
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PurchaseBillPage()));
                },
                child: Text(
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
        SizedBox(height: 20),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  indicatorColor: Color(0xff920000),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 4,
                  labelColor: const Color.fromARGB(255, 128, 0, 0),
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
                SizedBox(height: 10),
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
                            builder: (context) => BarcodeScannerWithList(),
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
                              builder: (context) => AddProductBills()),
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
      },
    );
  }
}
