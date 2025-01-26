import 'package:flutter/material.dart';
import 'package:nirogya/Views/Add%20Dealer%20Screen/add_dealer.dart';
import 'package:provider/provider.dart';

import '../../Model/Dealer/dealer.dart';
import '../../View Model/Dealer/dealer_view_model.dart';

class OrderStockPage extends StatefulWidget {
  @override
  _OrderStockPageState createState() => _OrderStockPageState();
}

class _OrderStockPageState extends State<OrderStockPage> {
  late DealerViewModel dealerProvider;
  bool _isLoading = true;

  Future<List<Dealer>> fetchDealer(BuildContext context) async {
    DealerViewModel dealerProvider = context.read<DealerViewModel>();
    await dealerProvider.fetchDealers();
    return dealerProvider.dealers;
  }

  void _onWhatsAppTap(String number) {
    // Add WhatsApp URL logic
    print("Open WhatsApp for $number");
  }

  void _onCallTap(String number) {
    // Add Call logic
    print("Calling $number");
  }

  @override
  void initState() {
    super.initState();
    _initializeDealers();
    // fetchDealer(context);
  }

  Future<void> _initializeDealers() async {
    dealerProvider = context.read<DealerViewModel>();
    try {
      await dealerProvider.fetchDealers();
    } catch (e) {
      print("Error fetching dealers: $e");
    } finally {
      setState(() {
        _isLoading = false; // Update loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // DealerProvider dealerProvider = context.read<DealerProvider>();
    // List<Dealer> dealers = dealerProvider.dealers;
    final dealerProvider = Provider.of<DealerViewModel>(context);
    // print(dealerProvider.dealers.length);

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
                itemCount: dealerProvider.dealers.length,
                itemBuilder: (context, index) {
                  final dealer = dealerProvider.dealers[index];
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
                        dealer.name,
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
                              "assets/images/whatsapp_red.png", // Replace with your asset path
                              height: 24,
                              width: 24,
                            ),
                            onPressed: () =>
                                _onWhatsAppTap(dealer.contactNumber),
                          ),
                          // Call Icon
                          IconButton(
                            icon: Image.asset(
                              "assets/images/phone.png", // Replace with your asset path
                              height: 24,
                              width: 24,
                            ),
                            onPressed: () => _onCallTap(dealer.contactNumber),
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
