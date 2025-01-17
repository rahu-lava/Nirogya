import 'package:flutter/material.dart';

class SalesSlide extends StatefulWidget {
  const SalesSlide({super.key});

  @override
  State<SalesSlide> createState() => _SalesSlideState();
}

class _SalesSlideState extends State<SalesSlide> {
  // Mock data for the cards
  final List<Map<String, String>> salesData = [
    {'title': 'Average Sales', 'value': '\$2,500'},
    {'title': 'Total Sales', 'value': '\$50,000'},
    {'title': 'Growth Rate', 'value': '15%'},
    {'title': 'Highest Sale', 'value': '\$10,000'},
    {'title': 'New Customers', 'value': '250'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: 55, // Height of the card row
        child: ListView.builder(
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
