import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../Data/Added Medicine/added_medicine_repo.dart';

class StockDashboard extends StatefulWidget {
  @override
  _StockDashboardState createState() => _StockDashboardState();
}

class _StockDashboardState extends State<StockDashboard> {
  Map<String, double> stockData = {}; // For pie chart percentages
  Map<String, int> stockCounts = {}; // For stats slide counts
  bool isLoading = true;
  bool hasSufficientData = false; // Flag to check if there is sufficient data

  @override
  void initState() {
    super.initState();
    _loadStockData();
  }

  Future<void> _loadStockData() async {
    final counts = await StockDataProcessor.getStockCounts(); // Fetch counts
    final totalMedicines = counts.values.reduce((a, b) => a + b);

    // Calculate percentages for the pie chart
    final percentages = {
      'inStock': (counts['inStock']! / totalMedicines) * 100,
      'lowStock': (counts['lowStock']! / totalMedicines) * 100,
      'outOfStock': (counts['outOfStock']! / totalMedicines) * 100,
    };

    setState(() {
      stockData = percentages;
      stockCounts = counts;
      isLoading = false;
      // Check if there is sufficient data (at least one non-zero count)
      hasSufficientData = counts.values.any((count) => count > 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pie Chart
        Container(
          height: 300,
          width: double.infinity,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : hasSufficientData
                  ? StocksPieChart(stockData: stockData)
                  : Center(
                      child: Text(
                        'No sufficient data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
        ),
        SizedBox(height: 20), // Space between pie chart and stats slide
        // Stats Slide
        hasSufficientData
            ? StockStatsSlide(stockCounts: stockCounts)
            : SizedBox(), // Hide stats slide if no sufficient data
      ],
    );
  }
}

class StocksPieChart extends StatelessWidget {
  final Map<String, double> stockData;

  StocksPieChart({required this.stockData});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            // Handle touch interactions if needed
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 5,
        centerSpaceRadius: 75,
        sections: stockData.entries.map((entry) {
          return PieChartSectionData(
            color: getColor(entry.key),
            value: entry.value,
            title: '${entry.value.toStringAsFixed(1)}%',
            radius: 50,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        }).toList(),
      ),
    );
  }

  Color getColor(String stockStatus) {
    switch (stockStatus) {
      case 'inStock':
        return Colors.green;
      case 'lowStock':
        return Colors.yellow;
      case 'outOfStock':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class StockStatsSlide extends StatelessWidget {
  final Map<String, int> stockCounts;

  const StockStatsSlide({super.key, required this.stockCounts});

  @override
  Widget build(BuildContext context) {
    // Convert stock counts to stats for the slide
    final List<Map<String, String>> stockStats = [
      {
        'title': 'In Stock',
        'value': stockCounts['inStock']?.toString() ?? '0',
        'color': 'green'
      },
      {
        'title': 'Low Stock',
        'value': stockCounts['lowStock']?.toString() ?? '0',
        'color': 'yellow'
      },
      {
        'title': 'Out of Stock',
        'value': stockCounts['outOfStock']?.toString() ?? '0',
        'color': 'red'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: 55, // Height of the card row
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: stockStats.length, // Number of cards
          itemBuilder: (context, index) {
            final data = stockStats[index];

            // Determine the color of the card based on the stats
            Color cardColor;
            switch (data['color']) {
              case 'green':
                cardColor = Colors.green.shade100;
                break;
              case 'yellow':
                cardColor = Colors.yellow.shade100;
                break;
              case 'red':
                cardColor = Colors.red.shade100;
                break;
              default:
                cardColor = Colors.white;
            }

            return Container(
              width: 275, // Width of each card
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
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

class StockDataProcessor {
  static Future<Map<String, int>> getStockCounts() async {
    final addedMedicines = await _fetchMedicinesFromRepository();

    int inStockCount = 0;
    int lowStockCount = 0;
    int outOfStockCount = 0;

    for (var medicine in addedMedicines) {
      final quantity = medicine['quantity'];
      if (quantity > 10) {
        inStockCount++;
      } else if (quantity > 0) {
        lowStockCount++;
      } else {
        outOfStockCount++;
      }
    }

    return {
      'inStock': inStockCount,
      'lowStock': lowStockCount,
      'outOfStock': outOfStockCount,
    };
  }

  // Fetch medicines from AddedMedicineRepository
  static Future<List<Map<String, dynamic>>>
      _fetchMedicinesFromRepository() async {
    final addedMedicineRepo = AddedMedicineRepository();
    final addedMedicines = await addedMedicineRepo.getAllAddedMedicines();

    if (addedMedicines.isEmpty) {
      print('No added medicines available.');
      return [];
    }

    // Convert medicine data to a list of maps
    return addedMedicines.map((medicine) {
      return {
        'id': medicine.finalMedicine.id,
        'productName': medicine.finalMedicine.medicine.productName,
        'quantity': medicine.finalMedicine.medicine.quantity,
        'batch': medicine.finalMedicine.medicine.batch,
        'dealerName': medicine.finalMedicine.medicine.dealerName,
        'gst': medicine.finalMedicine.medicine.gst,
        'companyName': medicine.finalMedicine.medicine.companyName ?? "N/A",
        'alertQuantity': medicine.finalMedicine.medicine.alertQuantity ?? "N/A",
        'description': medicine.finalMedicine.medicine.description ?? "N/A",
        'imagePath': medicine.finalMedicine.medicine.imagePath ?? "N/A",
        'scannedBarcodes': medicine.scannedBarcodes,
      };
    }).toList();
  }
}
