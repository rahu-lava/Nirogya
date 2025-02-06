import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
// import 'package:nirogya/Screen/CustomerDetails/customer_details.dart';

import '../CustomerDetails/customer_details.dart';

class AddProductBills extends StatefulWidget {
  const AddProductBills({super.key});

  @override
  State<AddProductBills> createState() => _AddProductBillsState();
}

class _AddProductBillsState extends State<AddProductBills> {
  final List<Map<String, dynamic>> scannedItems = [];
  final List<Map<String, dynamic>> allItems = [
    {'name': 'Paracetamol', 'price': 20},
    {'name': 'Ibuprofen', 'price': 50},
    {'name': 'Amoxicillin', 'price': 150},
    {'name': 'Vitamin C', 'price': 30},
  ];
  List<Map<String, dynamic>> searchResults = [];

  int _calculateTotal() {
    return scannedItems.fold(0, (sum, item) => sum + (item['price'] as int));
  }

  void _addItem(Map<String, dynamic> item) {
    setState(() {
      scannedItems.add(item);
    });
  }

  void _removeItem(int index) {
    setState(() {
      scannedItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xff920000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 70), // Space for the search bar
              Expanded(
                child: ListView.builder(
                  itemCount: scannedItems.length,
                  itemBuilder: (context, index) {
                    final item = scannedItems[index];
                    return ListTile(
                      title: Text(
                        item['name'] ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Quantity: 1'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '₹${item['price']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeItem(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ₹${_calculateTotal()}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onPressed: () {
                        // Logic for moving to the next screen
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //       builder: (context) => CustomerDetailsPage()),
                        // );
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          FloatingSearchBar(
            hint: 'Search for medicines...',
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            backgroundColor: Colors.white,
            automaticallyImplyBackButton: false,
            leadingActions: [
              Icon(Icons.search, color: Color(0xff920000)),
            ],
            actions: [
              Icon(Icons.mic, color: Color(0xff920000)),
            ],
            onQueryChanged: (query) {
              setState(() {
                if (query.isEmpty) {
                  searchResults = [];
                } else {
                  searchResults = allItems
                      .where((item) => item['name']
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                      .toList();
                }
              });
            },
            builder: (context, _) {
              return Material(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final item = searchResults[index];
                    return ListTile(
                      title: Text(item['name']),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () {
                          _addItem(item);
                          FloatingSearchBar.of(context)?.close();
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
