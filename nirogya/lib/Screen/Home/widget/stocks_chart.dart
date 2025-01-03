import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StocksPieChart extends StatefulWidget {
  final Map<String, double>
      expiryData; // Map to hold expiry data (expired, safe, soon)

  StocksPieChart({required this.expiryData});

  @override
  _StocksPieChartState createState() => _StocksPieChartState();
}

class _StocksPieChartState extends State<StocksPieChart> {
  int touchedIndex = -1;

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.expiryData.entries.length, (i) {
      final MapEntry<String, double> entry =
          widget.expiryData.entries.elementAt(i);
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = getColor(entry.key); // Get color based on expiry category

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${entry.value.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    });
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
    return Container(
      height: 300,
      width: double.infinity,
      child: PieChart(
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
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
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
    );
  }
}
