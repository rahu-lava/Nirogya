import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nirogya/Auth/auth_provider.dart';
import 'package:nirogya/Screen/Home/widget/greetingWidget.dart';
import 'package:nirogya/Screen/Home/widget/pie_chart.dart';
import 'package:nirogya/Screen/Home/widget/sales_cards.dart';
import 'package:nirogya/Screen/Login%20Screen/login.dart';
import 'package:provider/provider.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Map<String, double> expiryData = {
  'expired': 20.0,
  'safe': 60.0,
  'soon': 20.0,
};

class _HomePageState extends State<HomePage> {
  String _selectedValue = 'Week';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 4,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Image.asset(
              'assets/images/nirogya_logo_short.png', // Replace with your image path
              height: 100, // Set the desired height
              width: 100, // Set the desired width
            ),
          ),
          actions: [
            // Icon button on the trailing side of the AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: IconButton(
                icon: Icon(color: Color(0xff920000), Icons.notifications_none),
                onPressed: () {
                  // Add your icon action here
                  print("Notification icon tapped");
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
            minimum: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: double.infinity, child: GreetingWidget()),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color: Color(0xff920000), width: 3))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Aligns content to both ends
                        children: [
                          const Text(
                            'Sales Graph',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w500),
                          ),
                          // Dropdown button at the end
                          Container(
                            height: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: DropdownButton<String>(
                                value: _selectedValue,
                                iconEnabledColor: Color(0xff920000),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedValue = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Week',
                                  'Month',
                                  'Year'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TrendLineBarChart(),
                  SizedBox(height: 25),
                  SalesSlide(),
                  SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xff920000),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Add Stock",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        // SizedBox(width: MediaQuery.of(context).size.width * 0.1 ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xff920000),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Create Bill",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  ExpiryPieChart(expiryData: expiryData)
                ],
              ),
            )));
  }
}

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
          padding: const EdgeInsets.all(0),
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
