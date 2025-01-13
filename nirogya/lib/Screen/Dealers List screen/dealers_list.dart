import 'package:flutter/material.dart';
import 'package:nirogya/Screen/DealersDetail/dealers_detail.dart';

class OrderStockPage extends StatelessWidget {
  final List<Map<String, String>> dealers = [
    {"name": "Dealer 1", "phone": "1234567890", "whatsapp": "1234567890"},
    {"name": "Dealer 2", "phone": "9876543210", "whatsapp": "9876543210"},
    {"name": "Dealer 3", "phone": "5556667778", "whatsapp": "5556667778"},
  ];

  void _onWhatsAppTap(String number) {
    // Add WhatsApp URL logic
    print("Open WhatsApp for $number");
  }

  void _onCallTap(String number) {
    // Add Call logic
    print("Calling $number");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Stock"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Red Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddDealerScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF920000), // Red color
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Add Dealer",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            // List of Dealers
            Expanded(
              child: ListView.builder(
                itemCount: dealers.length,
                itemBuilder: (context, index) {
                  final dealer = dealers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      title: Text(
                        dealer['name']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // WhatsApp Icon
                          IconButton(
                            icon: Image.asset(
                              "assets/whatsapp.png", // Replace with your asset path
                              height: 24,
                              width: 24,
                            ),
                            onPressed: () =>
                                _onWhatsAppTap(dealer['whatsapp']!),
                          ),
                          // Call Icon
                          IconButton(
                            icon: Icon(Icons.phone, color: Colors.red),
                            onPressed: () => _onCallTap(dealer['phone']!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
