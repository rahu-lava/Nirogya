import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening WhatsApp and dialer
import 'package:nirogya/Views/Add%20Dealer%20Screen/add_dealer.dart';
import 'package:provider/provider.dart';
import '../../Model/Dealer/dealer.dart';
import '../../View Model/Dealer/dealer_view_model.dart';
import 'package:toasty_box/toast_enums.dart'; // For toast messages
import 'package:toasty_box/toast_service.dart'; // For toast messages

class OrderStockPage extends StatefulWidget {
  @override
  _OrderStockPageState createState() => _OrderStockPageState();
}

class _OrderStockPageState extends State<OrderStockPage> {
  late DealerViewModel dealerProvider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeDealers();
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

  // Open WhatsApp for the given number if the dealer has WhatsApp
  void _onWhatsAppTap(Dealer dealer) async {
    if (dealer.hasWhatsApp) {
      final url = "https://wa.me/+91${dealer.contactNumber}"; // WhatsApp URL
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print("Could not launch WhatsApp");
      }
    } else {
      // Show a warning toast if the dealer doesn't have WhatsApp
      ToastService.showWarningToast(
        context,
        length: ToastLength.medium,
        message: "${dealer.name} doesn't have WhatsApp.",
      );
    }
  }

  // Open dialer with the given number
  void _onCallTap(String number) async {
    final url = "tel:$number"; // Dialer URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch dialer");
    }
  }

  // Show a dialog to confirm deletion of the dealer
  void _showDeleteDialog(BuildContext context, Dealer dealer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Dealer"),
        content: Text("Are you sure you want to delete ${dealer.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await _deleteDealer(dealer);
              Navigator.pop(context);
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Delete the dealer from the database
  Future<void> _deleteDealer(Dealer dealer) async {
    try {
      await dealerProvider.deleteDealer(dealer);
      await dealerProvider.fetchDealers(); // Refresh the list
      setState(() {}); // Update the UI
    } catch (e) {
      print("Error deleting dealer: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dealerProvider = Provider.of<DealerViewModel>(context);

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
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 20),

            // List of Dealers
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: dealerProvider.dealers.length,
                      itemBuilder: (context, index) {
                        final dealer = dealerProvider.dealers[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: () => _showDeleteDialog(context, dealer),
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
                                    onPressed: () => _onWhatsAppTap(
                                        dealer), // Pass the dealer object
                                  ),
                                  // Call Icon
                                  IconButton(
                                    icon: Image.asset(
                                      "assets/images/phone.png", // Replace with your asset path
                                      height: 24,
                                      width: 24,
                                    ),
                                    onPressed: () =>
                                        _onCallTap(dealer.contactNumber),
                                  ),
                                ],
                              ),
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
