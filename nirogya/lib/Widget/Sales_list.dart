import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../Views/Sales Transaction Detail Screen/sales_transaction_detail_screen.dart';
import '../../Model/Sales Bill/sales_bill.dart'; // Import the SalesBill model
import '../../Data/Sales Bill/sales_bill_repo.dart'; // Import the SalesBill repository

class SalesList extends StatefulWidget {
  @override
  _SalesListState createState() => _SalesListState();
}

class _SalesListState extends State<SalesList> {
  TextEditingController _searchController = TextEditingController();
  List<SalesBill> sales = []; // List to store sales bills
  List<SalesBill> filteredSales = []; // List to store filtered sales bills

  @override
  void initState() {
    super.initState();
    _loadSalesBills(); // Load sales bills when the widget initializes
  }

  // Load sales bills from the repository
  Future<void> _loadSalesBills() async {
    final salesBills = await SalesBillRepository.getAllSalesBills();
    setState(() {
      sales = salesBills;
      filteredSales = salesBills;
    });
  }

  // Filter sales bills based on the search query
  void _filterSales(String query) {
    setState(() {
      filteredSales = sales
          .where((sale) =>
              sale.invoiceNumber.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            child: TextField(
              controller: _searchController,
              cursorColor: const Color(0xff006400), // Green for sales
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter,
                LengthLimitingTextInputFormatter(9),
              ],
              onChanged: _filterSales,
              decoration: const InputDecoration(
                hintText: 'NIR123456',
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xff006400),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff006400)),
                ),
              ),
            ),
          ),
        ),
        // Sales List
        Expanded(
          child: ListView.builder(
            itemCount: filteredSales.length,
            itemBuilder: (context, index) {
              var sale = filteredSales[index];
              // Calculate total amount for the sale
              double totalAmount = sale.medicines.fold(
                0.0,
                (sum, medicine) => sum + (medicine.price * medicine.quantity),
              );

              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.green
                          .withOpacity(0.8), // Green border for sales
                      width: 0.5,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text(
                      sale.invoiceNumber,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      '${sale.date.toLocal()}'.split(' ')[0], // Display date only
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: Text(
                      '\$${totalAmount.toStringAsFixed(2)}', // Display total amount
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    onTap: () {
                      // Navigate to Transaction Details screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SalesTransactionDetailsScreen(
                            salesBill: sale, // Pass the selected sales bill
                          ),
                        ),
                      );
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