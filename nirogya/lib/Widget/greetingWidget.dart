import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({Key? key}) : super(key: key);

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 18) {
      return "Good Afternoon";
    } else if (hour >= 18 && hour < 22) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  String getImagePath() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'assets/images/greeting_Images/morning.png'; // Replace with your morning PNG
    } else if (hour >= 12 && hour < 18) {
      return 'assets/images/greeting_Images/afternoon.png'; // Replace with your afternoon PNG
    } else if (hour >= 18 && hour < 22) {
      return 'assets/images/greeting_Images/evening.png'; // Replace with your evening PNG
    } else {
      return 'assets/images/greeting_Images/night.png'; // Replace with your night PNG
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "Welcome,",
          //   style: TextStyle(fontSize: 24),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                getGreeting(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              Image.asset(
                getImagePath(),
                height: 35,
                width: 35,
              ),
            ],
          ),
          Text(
            "12 Dec 2024",
            style:
                TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
