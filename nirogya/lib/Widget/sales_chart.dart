import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import '../../../Data/Sales Bill/sales_bill_repo.dart';

class TrendLineBarChart extends StatefulWidget {
  final String selectedPeriod;

  const TrendLineBarChart({Key? key, required this.selectedPeriod})
      : super(key: key);

  @override
  _TrendLineBarChartState createState() => _TrendLineBarChartState();
}

class _TrendLineBarChartState extends State<TrendLineBarChart> {
  List<BarChartGroupData> _barGroups = [];
  List<String> xAxisLabels = [];
  bool isLoading = true;
  bool hasData = false;
  double maxSalesValue = 0.0; // To store the maximum sales value

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
  }

  @override
  void didUpdateWidget(TrendLineBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedPeriod != widget.selectedPeriod) {
      _fetchSalesData();
    }
  }

  Future<void> _fetchSalesData() async {
    setState(() {
      isLoading = true;
    });

    final salesBills = await SalesBillRepository.getAllSalesBills();
    final now = DateTime.now();

    List<double> salesData = [];
    maxSalesValue = 0.0; // Reset max value

    switch (widget.selectedPeriod) {
      case 'Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        salesData = List.generate(7, (index) {
          final day = startOfWeek.add(Duration(days: index));
          final totalSales = salesBills.where((bill) {
            final billDate = DateTime.parse(bill.date.toString());
            return billDate.year == day.year &&
                billDate.month == day.month &&
                billDate.day == day.day;
          }).fold(0.0, (sum, bill) {
            return sum +
                bill.medicines.fold(
                    0.0,
                    (sum, medicine) =>
                        sum + (medicine.price * medicine.quantity));
          });
          if (totalSales > maxSalesValue) {
            maxSalesValue = totalSales;
          }
          return totalSales;
        });
        xAxisLabels = List.generate(7, (index) {
          final day = startOfWeek.add(Duration(days: index));
          return DateFormat('dd')
              .format(day); // Format: Day of the month (e.g., 01, 02)
        });
        break;

      case 'Month':
        final startOfMonth = DateTime(now.year, now.month, 1);
        final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
        salesData = List.generate(daysInMonth, (index) {
          final day = startOfMonth.add(Duration(days: index));
          final totalSales = salesBills.where((bill) {
            final billDate = DateTime.parse(bill.date.toString());
            return billDate.year == day.year &&
                billDate.month == day.month &&
                billDate.day == day.day;
          }).fold(0.0, (sum, bill) {
            return sum +
                bill.medicines.fold(
                    0.0,
                    (sum, medicine) =>
                        sum + (medicine.price * medicine.quantity));
          });
          if (totalSales > maxSalesValue) {
            maxSalesValue = totalSales;
          }
          return totalSales;
        });
        xAxisLabels = List.generate(daysInMonth, (index) {
          final day = startOfMonth.add(Duration(days: index));
          // Show labels at 5-day intervals
          if (index % 5 == 0) {
            return DateFormat('dd')
                .format(day); // Format: Day of the month (e.g., 01, 02)
          }
          return ''; // Empty label for other days
        });
        break;

      case 'Year':
        salesData = List.generate(12, (index) {
          final month = DateTime(now.year, index + 1, 1);
          final totalSales = salesBills.where((bill) {
            final billDate = DateTime.parse(bill.date.toString());
            return billDate.year == month.year && billDate.month == month.month;
          }).fold(0.0, (sum, bill) {
            return sum +
                bill.medicines.fold(
                    0.0,
                    (sum, medicine) =>
                        sum + (medicine.price * medicine.quantity));
          });
          if (totalSales > maxSalesValue) {
            maxSalesValue = totalSales;
          }
          return totalSales;
        });
        xAxisLabels = List.generate(12, (index) {
          final month = DateTime(now.year, index + 1, 1);
          return DateFormat('MMM')
              .format(month); // Format: Month abbreviation (e.g., Jan, Feb)
        });
        break;
    }

    setState(() {
      _barGroups = salesData.asMap().entries.map((entry) {
        return BarChartGroupData(
          x: entry.key,
          barRods: [
            BarChartRodData(
              width: 12,
              fromY: 0,
              color: Colors.red,
              toY: entry.value,
            ),
          ],
        );
      }).toList();

      hasData = salesData.any((value) => value > 0);
      isLoading = false;
    });
  }

  double _calculateYAxisInterval(double maxValue) {
    if (maxValue <= 100) {
      return maxValue / 3; // Small interval for small values
    } else if (maxValue <= 500) {
      return maxValue / 3; // Medium interval for medium values
    } else if (maxValue <= 1000) {
      return maxValue / 3; // Larger interval for larger values
    } else {
      return maxValue / 3; // Default interval for very large values
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 255,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        borderOnForeground: true,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 40),
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (!hasData)
                Center(
                  child: Text(
                    "No sales data available for the selected period.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 180,
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) =>
                              Color.fromARGB(255, 241, 186, 186),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              rod.toY.round().toString(),
                              TextStyle(
                                color: Color(0xff920000),
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: _calculateYAxisInterval(
                                maxSalesValue), // Dynamic interval
                            reservedSize:
                                40, // Increase reserved space for Y-axis labels
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value
                                    .toInt()
                                    .toString(), // Display integer values
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < xAxisLabels.length) {
                                return Text(
                                  xAxisLabels[index],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                );
                              }
                              return Text('');
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: _barGroups,
                      gridData: FlGridData(show: false),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
