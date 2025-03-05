import 'package:flutter/material.dart';
import '../../../Utils/permission_handler.dart';
import '../../../Widget/greetingWidget.dart';
import '../../../Widget/pie_chart.dart';
import '../../../Widget/sales_cards.dart';
import '../../../Widget/sales_chart.dart';
import '../../../Widget/stocks_chart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

// Map<String, double> expiryData = {
//   'expired': 20.0,
//   'safe': 60.0,
//   'soon': 20.0,
// };

class _DashboardState extends State<Dashboard> {
  String _selectedValue = 'Week';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PermissionHandlerUtil.requestPermissions(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Container(width: double.infinity, child: GreetingWidget()),
        SizedBox(height: 35),
        Container(
          decoration: BoxDecoration(
            border:
                Border(left: BorderSide(color: Color(0xff920000), width: 3)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sales Graph',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
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
                      items: <String>['Week', 'Month', 'Year']
                          .map<DropdownMenuItem<String>>((String value) {
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
        SizedBox(height: 10),
        TrendLineBarChart(
            selectedPeriod: _selectedValue), // Pass selected period
        SizedBox(height: 25),
        SalesSlide(),
        SizedBox(height: 25),
        Container(
          decoration: BoxDecoration(
            border:
                Border(left: BorderSide(color: Color(0xff920000), width: 3)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Text(
              'Expiry Stats',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),

        ExpiryPieChart(),
        // SizedBox(height: 10),
        // ExpiryStatsSlide(),
        SizedBox(height: 25),
        Container(
          decoration: BoxDecoration(
            border:
                Border(left: BorderSide(color: Color(0xff920000), width: 3)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Text(
              'Stocks Stats',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),

        StockDashboard(),
        // SizedBox(height: 10),
        // StockStatsSlide(),
      ],
    );
  }
}
