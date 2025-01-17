import 'package:flutter/material.dart';
import 'package:nirogya/Views%20&%20Controllers/Add%20Stock%20Screen/add_stock.dart';
import 'package:nirogya/Views%20&%20Controllers/PurchaseBillPage/purchase_bill_add_product.dart';

class PurchaseProductList extends StatelessWidget {
  final List<Map<String, String>> medicines = List.generate(20, (index) {
    return {
      "name": "Medicine ${index + 1}",
      "price": "\$${(index + 1) * 10}",
      "quantity": "Qty: ${index + 5}",
      "batch": "Batch: ${String.fromCharCode(65 + index)}123",
      "expiry": "Expiry: ${index + 1}/2025",
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Purchase Products"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Add Manually Button
                ElevatedButton(
                  onPressed: () {
                    // Add action for "Add Manually"
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PurchaseBillPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff920000),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Add More",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                // Medicine List (Scrollable)
                Expanded(
                  child: ListView.builder(
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      final medicine = medicines[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Medicine Name
                              Text(
                                medicine["name"]!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              // Details (Row with 2 Columns)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // First Column: Price and Quantity
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Price: ${medicine["price"]}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Quantity: ${medicine["quantity"]}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20), // Space between columns
                                  // Second Column: Batch and Expiry
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Batch: ${medicine["batch"]}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Expiry: ${medicine["expiry"]}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 70), // Space below before sticky buttons
              ],
            ),
          ),
          // Sticky Button at the Bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Proceed Button
                  ElevatedButton(
                    onPressed: () {
                      // Add action for "Proceed"
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Proceed",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
