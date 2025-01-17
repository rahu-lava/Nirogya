import 'package:flutter/material.dart';

class ExpiryStatsSlide extends StatefulWidget {
  const ExpiryStatsSlide({super.key});

  @override
  State<ExpiryStatsSlide> createState() => _ExpiryStatsSlideState();
}

class _ExpiryStatsSlideState extends State<ExpiryStatsSlide> {
  // Mock data for expiry stats
  final List<Map<String, String>> expiryStats = [
    {'title': 'Safe', 'value': '120', 'color': 'green'},
    {'title': 'Soon Expiring', 'value': '25', 'color': 'yellow'},
    {'title': 'Expired', 'value': '10', 'color': 'red'},
  ];

  @override
  Widget build(BuildContext context) {
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
                // border: Border.all(
                //   color: const Color.fromARGB(255, 250, 196, 196),
                //   width: 1,
                // ),
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
