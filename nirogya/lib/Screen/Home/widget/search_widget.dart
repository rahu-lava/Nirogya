import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nirogya/Screen/Stock%20info%20Screen/Stock_info_screen.dart';

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
                  borderRadius:
                      BorderRadius.circular(15.0), // Set border radius
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15.0), // Set border radius
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15.0), // Set border radius
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
              return GestureDetector(
                onTap: () {
                  // Navigate to Stock Info Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StockInfoScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border(
                          right: BorderSide(
                            color: const Color.fromARGB(
                                255, 204, 28, 16), // Red border for stock
                            width: 4.5,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255)
                                        .withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    "assets/images/no_preview_img.webp",
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          stock['id']!,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Expiry:",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  "Quantity:",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  "Batch:",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                SizedBox(height: 3),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: Text(
                                                stock['amount']!,
                                                style: TextStyle(fontSize: 24),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )),
                      )
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 10),
                      //   child: ListTile(
                      //     title: Text(
                      //       stock['id']!,
                      //       style: TextStyle(
                      //           fontSize: 24,
                      //           fontFamily: 'Poppins',
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //     subtitle: Text(
                      //       'Expiry: ${stock['expiry']}',
                      //       style: TextStyle(
                      //           fontSize: 16,
                      //           fontFamily: 'Poppins',
                      //           fontWeight: FontWeight.w400),
                      //     ),
                      //     trailing: Text(
                      //       stock['amount']!,
                      //       style: TextStyle(
                      //           fontSize: 18,
                      //           fontFamily: 'Poppins',
                      //           fontWeight: FontWeight.w300),
                      //     ),
                      //   ),
                      // ),
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
