import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../Data/Added Medicine/added_medicine_repo.dart'; // For date parsing and formatting

class ExpiryPieChart extends StatefulWidget {
  @override
  _ExpiryPieChartState createState() => _ExpiryPieChartState();
}

class _ExpiryPieChartState extends State<ExpiryPieChart> {
  Map<String, int> expiryCounts = {}; // Store counts instead of percentages
  bool isLoading = true;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadExpiryData();
  }

  Future<void> _loadExpiryData() async {
    final counts = await ExpiryDataProcessor.getExpiryCounts(); // Fetch counts
    setState(() {
      expiryCounts = counts;
      isLoading = false;
    });
  }

  List<PieChartSectionData> showingSections() {
    final totalMedicines = expiryCounts.values.reduce((a, b) => a + b);

    return expiryCounts.entries.map((entry) {
      final isTouched = entry.key == touchedIndex.toString();
      final fontSize = isTouched ? 18.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = getColor(entry.key); // Get color based on expiry category

      final percentage = (entry.value / totalMedicines) * 100;

      return PieChartSectionData(
        color: color,
        value: percentage, // Use percentage for the pie chart
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();
  }

  Color getColor(String expiry) {
    switch (expiry) {
      case 'expired':
        return Colors.red;
      case 'safe':
        return Colors.green;
      case 'soon':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 5,
                    centerSpaceRadius: 75,
                    sections: showingSections(),
                  ),
                ),
        ),
        SizedBox(height: 20), // Space between pie chart and stats slide
        ExpiryStatsSlide(
            expiryCounts: expiryCounts), // Pass the expiry counts to the slide
      ],
    );
  }
}

class ExpiryStatsSlide extends StatelessWidget {
  final Map<String, int> expiryCounts;

  const ExpiryStatsSlide({super.key, required this.expiryCounts});

  @override
  Widget build(BuildContext context) {
    // Convert expiry counts to stats for the slide
    final List<Map<String, String>> expiryStats = [
      {
        'title': 'Safe',
        'value': expiryCounts['safe']?.toString() ?? '0',
        'color': 'green'
      },
      {
        'title': 'Soon Expiring',
        'value': expiryCounts['soon']?.toString() ?? '0',
        'color': 'yellow'
      },
      {
        'title': 'Expired',
        'value': expiryCounts['expired']?.toString() ?? '0',
        'color': 'red'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: 55, // Height of the card row
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: expiryStats.length, // Number of cards
          itemBuilder: (context, index) {
            final data = expiryStats[index];

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

class ExpiryDataProcessor {
  static Future<Map<String, int>> getExpiryCounts() async {
    final addedMedicines = await _fetchMedicinesFromRepository();

    int expiredCount = 0;
    int soonExpiringCount = 0;
    int safeCount = 0;

    final now = DateTime.now();
    final soonExpiryThreshold =
        now.add(Duration(days: 60)); // 2 months from now

    for (var medicine in addedMedicines) {
      final expiryDate = DateFormat('dd/MM/yyyy').parse(medicine['expiryDate']);

      if (expiryDate.isBefore(now)) {
        expiredCount++;
      } else if (expiryDate.isBefore(soonExpiryThreshold)) {
        soonExpiringCount++;
      } else {
        safeCount++;
      }
    }

    return {
      'expired': expiredCount,
      'soon': soonExpiringCount,
      'safe': safeCount,
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
        'expiryDate': medicine.finalMedicine.medicine.expiryDate,
        'price': medicine.finalMedicine.medicine.price,
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
