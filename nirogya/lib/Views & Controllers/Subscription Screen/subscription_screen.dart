import 'package:flutter/material.dart';

class PremiumSubscriptionScreen extends StatelessWidget {
  const PremiumSubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Plans'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF920000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Your Plan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Start your 7-day free trial today and unlock premium features!',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: PageController(viewportFraction: 0.8),
                children: [
                  _buildPlanCard(
                    title: 'Basic Plan',
                    basePrice: 0,
                    durations: const {
                      '1 Month': 0,
                      '3 Months': 0,
                      '6 Months': 0,
                      '1 Year': 0,
                    },
                    features: [
                      'Ad-free experience',
                      'Offline access',
                      'Data access (up to 3 months)',
                    ],
                    color: Colors.white,
                  ),
                  _buildPlanCard(
                    title: 'Silver Plan',
                    basePrice: 99,
                    durations: const {
                      '1 Month': 99,
                      '3 Months': 279,
                      '6 Months': 549,
                      '1 Year': 999,
                    },
                    features: [
                      'All Basic Plan benefits',
                      'Weekly backup',
                      'Access to download page',
                      'Data access (up to 6 months)',
                      'Unlabeled PDF bills',
                    ],
                    color: const Color(0xFFE0E0E0), // Silver color
                  ),
                  _buildPlanCard(
                    title: 'Gold Plan',
                    basePrice: 149,
                    durations: const {
                      '1 Month': 149,
                      '3 Months': 399,
                      '6 Months': 849,
                      '1 Year': 1399,
                    },
                    features: [
                      'All Silver Plan benefits',
                      'Daily backup',
                      'Web access',
                      'Attendance system',
                      'Unlimited data storage',
                    ],
                    color: const Color(0xFFFFD700), // Gold color
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement subscription logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF920000),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Start Free Trial',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required int basePrice,
    required Map<String, int> durations,
    required List<String> features,
    required Color color,
  }) {
    ValueNotifier<String> selectedDuration = ValueNotifier('1 Month');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<String>(
            valueListenable: selectedDuration,
            builder: (context, duration, child) {
              return Text(
                '₹${durations[duration]}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF920000),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: durations.keys.map((duration) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(duration),
                    selected: selectedDuration.value == duration,
                    onSelected: (isSelected) {
                      if (isSelected) selectedDuration.value = duration;
                    },
                    selectedColor: const Color(0xFF920000), // Active color
                    backgroundColor:
                        Colors.grey[200], // Inactive background color
                    labelStyle: TextStyle(
                      color: selectedDuration.value == duration
                          ? Colors.white // Active text color
                          : Colors.black, // Inactive text color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: features.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    const Icon(Icons.check, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        features[index],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement subscription for the selected duration
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF920000),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Subscribe Now',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
