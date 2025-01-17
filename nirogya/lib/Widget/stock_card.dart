import 'package:flutter/material.dart';

class StockStatsSlide extends StatefulWidget {
  const StockStatsSlide({super.key});

  @override
  State<StockStatsSlide> createState() => _StockStatsSlideState();
}

class _StockStatsSlideState extends State<StockStatsSlide> {
  // Mock data for stock stats
  final List<Map<String, String>> stockStats = [
    {'title': 'In Stock', 'value': '300', 'color': 'green'},
    {'title': 'Low Stock', 'value': '50', 'color': 'yellow'},
    {'title': 'Out of Stock', 'value': '10', 'color': 'red'},
  ];

  @override
  Widget build(BuildContext context) {
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
