import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Views & Controllers/Sales Transaction Detail Screen/sales_transaction_detail_screen.dart';

class SalesList extends StatefulWidget {
  @override
  _SalesListState createState() => _SalesListState();
}

class _SalesListState extends State<SalesList> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> sales = [
    {'id': 'NIR12a456', 'amount': '\$500.00', 'date': '2024-02-01'},
    {'id': 'NIR12b789', 'amount': '\$250.25', 'date': '2024-02-05'},
    {'id': 'NIR12c012', 'amount': '\$399.99', 'date': '2024-02-10'},
    {'id': 'NIR12d345', 'amount': '\$600.75', 'date': '2024-02-15'},
    {'id': 'NIR12e678', 'amount': '\$150.50', 'date': '2024-02-20'},
    // Add more sales data as needed
  ];

  List<Map<String, String>> filteredSales = [];

  @override
  void initState() {
    super.initState();
    filteredSales = sales;
  }

  void _filterSales(String query) {
    setState(() {
      filteredSales = sales
          .where(
              (sale) => sale['id']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
        Expanded(
          child: ListView.builder(
            itemCount: filteredSales.length,
            itemBuilder: (context, index) {
              var sale = filteredSales[index];
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
                      sale['id']!,
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${sale['date']}',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400),
                    ),
                    trailing: Text(
                      sale['amount']!,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      // Navigate to Transaction Details screen
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (contect) =>
                              SalesTransactionDetailsScreen()));
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
