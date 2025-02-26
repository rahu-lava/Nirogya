import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../../../Data/Sales Bill/sales_bill_repo.dart'; // Adjust the import based on your project structure

class SalesSlide extends StatefulWidget {
  const SalesSlide({super.key});

  @override
  State<SalesSlide> createState() => _SalesSlideState();
}

class _SalesSlideState extends State<SalesSlide> {
  List<Map<String, String>> salesData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
  }

  Future<void> _fetchSalesData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final salesBills = await SalesBillRepository.getAllSalesBills();
      print('Fetched ${salesBills.length} sales bills'); // Debug print

      // Calculate total sales, average sales, and highest sale
      double totalSales = salesBills.fold(0.0, (sum, bill) {
        return sum +
            bill.medicines.fold(0.0,
                (sum, medicine) => sum + (medicine.price * medicine.quantity));
      });

      double averageSales =
          salesBills.isNotEmpty ? totalSales / salesBills.length : 0.0;

      double highestSale = salesBills.fold(0.0, (max, bill) {
        final billTotal = bill.medicines.fold(
            0.0, (sum, medicine) => sum + (medicine.price * medicine.quantity));
        return billTotal > max ? billTotal : max;
      });

      // Update salesData
      setState(() {
        salesData = [
          {
            'title': 'Average Sales',
            'value': '₹${averageSales.toStringAsFixed(2)}'
          },
          {
            'title': 'Total Sales',
            'value': '₹${totalSales.toStringAsFixed(2)}'
          },
          {
            'title': 'Highest Sale',
            'value': '₹${highestSale.toStringAsFixed(2)}'
          },
        ];
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching sales data: $e'); // Debug print
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: 55, // Height of the card row
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: salesData.length, // Number of cards
                itemBuilder: (context, index) {
                  final data = salesData[index];
                  return Container(
                    width: 275, // Width of each card
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color.fromARGB(255, 250, 196, 196),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          Text(
                            data['title']!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Value
                          Text(
                            data['value']!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
