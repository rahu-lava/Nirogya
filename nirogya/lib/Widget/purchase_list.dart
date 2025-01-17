import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Views & Controllers/Purchase Transaction Screen/purchase_transactiondetails_screen.dart';

class PurchaseList extends StatefulWidget {
  @override
  _PurchaseListState createState() => _PurchaseListState();
}

class _PurchaseListState extends State<PurchaseList> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> purchases = [
    {'id': 'NIR12a456', 'amount': '\$300.00', 'date': '2024-01-01'},
    {'id': 'NIR12b789', 'amount': '\$150.25', 'date': '2024-01-05'},
    {'id': 'NIR12c012', 'amount': '\$89.99', 'date': '2024-01-10'},
    {'id': 'NIR12d345', 'amount': '\$200.75', 'date': '2024-01-15'},
    {'id': 'NIR12e678', 'amount': '\$50.50', 'date': '2024-01-20'},
    // Add more purchase data as needed
  ];

  List<Map<String, String>> filteredPurchases = [];

  @override
  void initState() {
    super.initState();
    filteredPurchases = purchases;
  }

  void _filterPurchases(String query) {
    setState(() {
      filteredPurchases = purchases
          .where((purchase) =>
              purchase['id']!.toLowerCase().contains(query.toLowerCase()))
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
              cursorColor: const Color(0xff8B0000), // Dark Red
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter,
                LengthLimitingTextInputFormatter(9),
              ],
              onChanged: _filterPurchases,
              decoration: const InputDecoration(
                hintText: 'NIR123456',
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xff8B0000), // Dark Red for icon
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
            itemCount: filteredPurchases.length,
            itemBuilder: (context, index) {
              var purchase = filteredPurchases[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.red.withOpacity(0.8), // Red border
                      width: 0.5,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text(
                      purchase['id']!,
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${purchase['date']}',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400),
                    ),
                    trailing: Text(
                      purchase['amount']!,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      // Navigate to PurchaseTransactionDetailsScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PurchaseTransactionDetailsScreen(),
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
