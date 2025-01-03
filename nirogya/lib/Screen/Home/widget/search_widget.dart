import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchStockWidget extends StatefulWidget {
  @override
  _SearchStockWidgetState createState() => _SearchStockWidgetState();
}

class _SearchStockWidgetState extends State<SearchStockWidget> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> stocks = [
    {'id': 'Paracetamol', 'amount': '\$5.00', 'expiry': '2025-06-01'},
    {'id': 'Ibuprofen', 'amount': '\$3.00', 'expiry': '2025-06-10'},
    {'id': 'Aspirin', 'amount': '\$2.50', 'expiry': '2025-06-15'},
    {'id': 'Cough Syrup', 'amount': '\$4.00', 'expiry': '2025-07-01'},
    {'id': 'Vitamin C', 'amount': '\$1.50', 'expiry': '2025-08-01'},
    // Add more stock items here
  ];

  List<Map<String, String>> filteredStocks = [];

  @override
  void initState() {
    super.initState();
    filteredStocks = stocks;
  }

  void _filterStocks(String query) {
    setState(() {
      filteredStocks = stocks
          .where((stock) =>
              stock['id']!.toLowerCase().contains(query.toLowerCase()))
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
              cursorColor: Color(0xff920000), // Red for focus
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter,
                LengthLimitingTextInputFormatter(15),
              ],
              onChanged: _filterStocks,
              decoration: InputDecoration(
                hintText: 'Search Stock...',
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xff920000), // Always red
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.mic,
                        color: Color(0xff920000), // Always red
                      ),
                      onPressed: () {
                        // Handle microphone icon action
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: Color(0xff920000), // Always red
                      ),
                      onPressed: () {
                        // Handle filter icon action
                      },
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff920000)),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredStocks.length,
            itemBuilder: (context, index) {
              var stock = filteredStocks[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color:
                          Colors.red.withOpacity(0.8), // Red border for stock
                      width: 0.5,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text(
                      stock['id']!,
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Expiry: ${stock['expiry']}',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400),
                    ),
                    trailing: Text(
                      stock['amount']!,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300),
                    ),
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
