import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TrendLineBarChart extends StatefulWidget {
  @override
  _TrendLineBarChartState createState() => _TrendLineBarChartState();
}

class _TrendLineBarChartState extends State<TrendLineBarChart> {
  List<BarChartGroupData> _barGroups = [];
  List<FlSpot> _lineSpots = [];

  @override
  void initState() {
    super.initState();
    _generateSampleData();
  }

  void _generateSampleData() {
    final barGroup1 = BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          width: 20,
          fromY: 0,
          color: Colors.red,
          toY: 8,
        ),
      ],
    );

    final barGroup2 = BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
          fromY: 0,
          width: 20,
          color: Colors.red,
          toY: 10,
        ),
      ],
    );

    final barGroup3 = BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
          fromY: 0,
          color: Colors.red,
          width: 20,
          toY: 8,
        ),
      ],
    );

    final barGroup4 = BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          width: 20,
          fromY: 0,
          color: Colors.red,
          toY: 8,
        ),
      ],
    );

    _barGroups = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup2,
      barGroup3,
      barGroup4
    ];

    _lineSpots = [
      FlSpot(0, 0),
      FlSpot(1, 9),
      FlSpot(2, 6),
      FlSpot(3, 11),
    ];
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
        // color: Color.fromARGB(255, 250, 209, 209),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[],
              ),
              const SizedBox(
                height: 40,
              ),
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
                          interval: 5,
                          reservedSize: 25,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          reservedSize: 20,
                          interval: 5,
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
              const SizedBox(
                height: 12,
              ),
              // Expanded(
              //   child: LineChart(
              //     LineChartData(
              //       lineTouchData: LineTouchData(
              //         enabled: false,
              //       ),
              //       gridData: FlGridData(
              //         show: false,
              //       ),
              //       titlesData: FlTitlesData(
              //         show: true,
              //         topTitles: AxisTitles(
              //           sideTitles: SideTitles(showTitles: false),
              //         ),
              //         rightTitles: AxisTitles(
              //           sideTitles: SideTitles(showTitles: false),
              //         ),
              //         leftTitles: AxisTitles(
              //           sideTitles: SideTitles(showTitles: false),
              //         ),
              //         bottomTitles: AxisTitles(
              //           sideTitles: SideTitles(
              //             showTitles: true,
              //             reservedSize: 22,
              //             interval: 1,
              //           ),
              //         ),
              //       ),
              //       borderData: FlBorderData(
              //         show: false,
              //       ),
              //       lineBarsData: [
              //         LineChartBarData(
              //           spots: _lineSpots,
              //           isCurved: true,
              //           barWidth: 2,
              //           color: Colors.black,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
