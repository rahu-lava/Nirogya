import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Data/Bill/bill_repository.dart';
import '../Model/Medicine/medicine.dart';
import '../Views/Purchase Transaction Screen/purchase_transactiondetails_screen.dart';
import '../../Model/Bill/bill.dart';

class PurchaseList extends StatefulWidget {
  @override
  _PurchaseListState createState() => _PurchaseListState();
}

class _PurchaseListState extends State<PurchaseList> {
  TextEditingController _searchController = TextEditingController();
  List<Bill> bills = [];
  List<Bill> filteredBills = [];

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  Future<void> _loadBills() async {
    List<Bill> allBills = await BillRepository.getAllBills();
    setState(() {
      bills = allBills;
      filteredBills = allBills;
    });
  }

  void _filterBills(String query) {
    setState(() {
      filteredBills = bills
          .where((bill) =>
              bill.invoiceNumber.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  double _calculateTotalAmount(List<Medicine> medicines) {
    double totalAmount = 0.0;
    for (var medicine in medicines) {
      double priceWithoutGST = medicine.price * medicine.quantity;
      double gstAmount = priceWithoutGST * (medicine.gst / 100);
      totalAmount += priceWithoutGST + gstAmount;
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            child: TextField(
              controller: _searchController,
              cursorColor: const Color(0xff8B0000),
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter,
                LengthLimitingTextInputFormatter(9),
              ],
              onChanged: _filterBills,
              decoration: const InputDecoration(
                hintText: 'Search Invoice Number',
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xff8B0000),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff8B0000)),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredBills.length,
            itemBuilder: (context, index) {
              var bill = filteredBills[index];
              double totalAmount = _calculateTotalAmount(bill.medicines);

              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.red.withOpacity(0.8),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text(
                      bill.invoiceNumber,
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${bill.date.toLocal()}'.split(' ')[0],
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400),
                    ),
                    trailing: Text(
                      '₹${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PurchaseTransactionDetailsScreen(
                            supplierName: bill.dealerName,
                            supplierContact: bill.dealerContact,
                            gstin: bill.gstNumber,
                            medicines: bill.medicines
                                .map((medicine) => {
                                      "name": medicine.productName,
                                      "price": medicine.price.toString(),
                                      "quantity": medicine.quantity.toString(),
                                      "batch": medicine.batch,
                                      "expiry": medicine.expiryDate,
                                    })
                                .toList(),
                            transactionId: bill.invoiceNumber,
                            totalAmount: totalAmount.toString(),
                            paymentMode: "-",
                          ),
                        ),
                      ).then((_) {
                        // Refresh the bill list after returning from the detail screen
                        _loadBills();
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
