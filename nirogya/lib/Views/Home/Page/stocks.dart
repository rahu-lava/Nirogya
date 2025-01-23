import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nirogya/View%20Model/Dealer/dealer_provider.dart';
import 'package:nirogya/Views/Add%20Stock%20Scanner/scanner_add_stock.dart';
import 'package:nirogya/Views/AddProductBills/add_product_bills.dart';
import 'package:nirogya/Views/Added%20Product%20Screen/added_product_list.dart';
import 'package:nirogya/Views/Dealers%20List%20screen/dealers_list.dart';
import 'package:nirogya/Widget/confirmation_dailog.dart';
import 'package:nirogya/Widget/search_widget.dart';
import 'package:nirogya/Widget/stocks_card.dart';
import 'package:nirogya/Views/Barcode%20Scanner%20Bills/barcode_scanner_bills.dart';
import 'package:provider/provider.dart';

import '../../../Model/Dealer/dealer.dart';

class Stocks extends StatefulWidget {
  const Stocks({super.key});

  @override
  State<Stocks> createState() => _StocksState();
}

class _StocksState extends State<Stocks> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StocksCard(title: "Expired", amount: "4", isYellow: false),
            StocksCard(title: "Soon Expiry", amount: "9", isYellow: true)
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StocksCard(title: "Out of Stock", amount: "4", isYellow: false),
            StocksCard(title: "Low Stock", amount: "9", isYellow: true)
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
                  ShowDailog(context);
                },
                child: Text(
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
