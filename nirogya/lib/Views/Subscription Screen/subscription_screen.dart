import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Successful!")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Failed! Please try again.")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("External Wallet Selected.")),
    );
  }

  void _openRazorpay() {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag', // Replace with your Razorpay key
      'amount': 4900, // Amount in paise (₹49)
      'name': 'Support Our Project',
      'description': 'Subscription for Download & Attendance Access',
      'prefill': {'contact': '', 'email': ''},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
        centerTitle: true,
        backgroundColor: const Color(0xFF920000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Center(
                child: Image.asset(
                  'assets/images/nirogya_short_gold.png', // Replace with your logo
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Premium Subscription',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '₹49/month',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF920000),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Support Our Project and get access to:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    const ListTile(
                      leading: Icon(Icons.download, color: Colors.green),
                      title: Text('Download Page Access'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('Attendance Page Access'),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: _openRazorpay,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF920000),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Subscribe Now',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';

// class PremiumSubscriptionScreen extends StatelessWidget {
//   const PremiumSubscriptionScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Premium Plans'),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: const Color(0xFF920000),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Choose Your Plan',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Start your 7-day free trial today and unlock premium features!',
//               style: TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: PageView(
//                 controller: PageController(viewportFraction: 0.8),
//                 children: [
//                   _buildPlanCard(
//                     title: 'Basic Plan',
//                     basePrice: 0,
//                     durations: const {
//                       '1 Month': 0,
//                       '3 Months': 0,
//                       '6 Months': 0,
//                       '1 Year': 0,
//                     },
//                     features: [
//                       'Ad-free experience',
//                       'Offline access',
//                       'Data access (up to 3 months)',
//                     ],
//                     color: Colors.white,
//                   ),
//                   _buildPlanCard(
//                     title: 'Silver Plan',
//                     basePrice: 99,
//                     durations: const {
//                       '1 Month': 99,
//                       '3 Months': 279,
//                       '6 Months': 549,
//                       '1 Year': 999,
//                     },
//                     features: [
//                       'All Basic Plan benefits',
//                       'Weekly backup',
//                       'Access to download page',
//                       'Data access (up to 6 months)',
//                       'Unlabeled PDF bills',
//                     ],
//                     color: const Color(0xFFE0E0E0), // Silver color
//                   ),
//                   _buildPlanCard(
//                     title: 'Gold Plan',
//                     basePrice: 149,
//                     durations: const {
//                       '1 Month': 149,
//                       '3 Months': 399,
//                       '6 Months': 849,
//                       '1 Year': 1399,
//                     },
//                     features: [
//                       'All Silver Plan benefits',
//                       'Daily backup',
//                       'Web access',
//                       'Attendance system',
//                       'Unlimited data storage',
//                     ],
//                     color: const Color(0xFFFFD700), // Gold color
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Implement subscription logic here
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF920000),
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 15,
//                     horizontal: 50,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: const Text(
//                   'Start Free Trial',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPlanCard({
//     required String title,
//     required int basePrice,
//     required Map<String, int> durations,
//     required List<String> features,
//     required Color color,
//   }) {
//     ValueNotifier<String> selectedDuration = ValueNotifier('1 Month');

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 8),
//           ValueListenableBuilder<String>(
//             valueListenable: selectedDuration,
//             builder: (context, duration, child) {
//               return Text(
//                 '₹${durations[duration]}',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF920000),
//                 ),
//               );
//             },
//           ),
//           const SizedBox(height: 10),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: durations.keys.map((duration) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   child: ChoiceChip(
//                     label: Text(duration),
//                     selected: selectedDuration.value == duration,
//                     onSelected: (isSelected) {
//                       if (isSelected) selectedDuration.value = duration;
//                     },
//                     selectedColor: const Color(0xFF920000), // Active color
//                     backgroundColor:
//                         Colors.grey[200], // Inactive background color
//                     labelStyle: TextStyle(
//                       color: selectedDuration.value == duration
//                           ? Colors.white // Active text color
//                           : Colors.black, // Inactive text color
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: ListView.builder(
//               itemCount: features.length,
//               itemBuilder: (context, index) {
//                 return Row(
//                   children: [
//                     const Icon(Icons.check, color: Colors.green),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         features[index],
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Implement subscription for the selected duration
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF920000),
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: const Text(
//               'Subscribe Now',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
