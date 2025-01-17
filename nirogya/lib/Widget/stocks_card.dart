import 'package:flutter/material.dart';

class StocksCard extends StatelessWidget {
  final String title;
  final String amount;
  final bool isYellow; // Parameter to decide the color

  const StocksCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.isYellow, // Accept color choice as parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 100, // Smaller height
      child: Card(
        color: isYellow
            ? Colors.yellow.shade100
            : Colors.red.shade100, // Color changes based on `isYellow`
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: isYellow
                ? Colors.yellow.shade400
                : Colors.red.shade400, // Color border also based on `isYellow`
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  amount,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26, // Smaller font size
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18, // Smaller font size
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
