// import 'package:flutter/material.dart';
// import 'package:nirogya/Screen/Home/widget/bills_card.dart';

// class AttendanceScreen extends StatefulWidget {
//   const AttendanceScreen({super.key});

//   @override
//   State<AttendanceScreen> createState() => _AttendanceScreenState();
// }

// class _AttendanceScreenState extends State<AttendanceScreen> {
//   // Employee list for dropdown
//   final List<String> employees = [
//     'John Doe',
//     'Jane Smith',
//     'Alice Johnson',
//     'Bob Brown'
//   ];

//   // Common widget for list items
//   Widget staffListItem(String name) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ListTile(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         tileColor: Colors.grey.shade200,
//         title: Text(
//           name,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }

//   // Function to show Clock In dialog
//   void showClockInDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Clock In",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(
//                     labelText: "Select Employee",
//                     border: OutlineInputBorder(),
//                   ),
//                   items: employees
//                       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                       .toList(),
//                   onChanged: (value) {},
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   decoration: const InputDecoration(
//                     labelText: "Time (hh:mm AM/PM)",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   decoration: const InputDecoration(
//                     labelText: "Date (dd/mm/yyyy)",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   child: const Text("Mark"),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Function to show Clock Out dialog
//   void showClockOutDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Clock Out",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(
//                     labelText: "Select Employee",
//                     border: OutlineInputBorder(),
//                   ),
//                   items: employees
//                       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                       .toList(),
//                   onChanged: (value) {},
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text("Time In", style: TextStyle(fontSize: 14)),
//                         SizedBox(height: 5),
//                         Text("08:00 AM", style: TextStyle(fontSize: 16)),
//                         Text("12/01/2025", style: TextStyle(fontSize: 14)),
//                       ],
//                     ),
//                     const Icon(Icons.arrow_forward, size: 24),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text("Time Out", style: TextStyle(fontSize: 14)),
//                         SizedBox(height: 5),
//                         Text("05:00 PM", style: TextStyle(fontSize: 16)),
//                         Text("12/01/2025", style: TextStyle(fontSize: 14)),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   child: const Text("Mark"),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Attendance"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xff920000),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: const Text(
//                 "Add New Employee",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 BillsCard(title: "Staff Count", amount: "12"),
//                 BillsCard(title: "At Work", amount: "8"),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: showClockInDialog,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xff920000),
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     child: const Text("Clock In"),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: showClockOutDialog,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xff920000),
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     child: const Text("Clock Out"),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: DefaultTabController(
//                 length: 2,
//                 child: Column(
//                   children: [
//                     TabBar(
//                       indicatorColor: const Color(0xff920000),
//                       indicatorSize: TabBarIndicatorSize.tab,
//                       indicatorWeight: 4,
//                       labelColor: const Color.fromARGB(255, 128, 0, 0),
//                       unselectedLabelColor: Colors.grey,
//                       labelStyle: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold),
//                       tabs: const [
//                         Tab(text: "All Staff"),
//                         Tab(text: "Staff On Work"),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Expanded(
//                       child: TabBarView(
//                         children: [
//                           ListView(
//                             children: employees
//                                 .map((name) => staffListItem(name))
//                                 .toList(),
//                           ),
//                           ListView(
//                             children: employees
//                                 .take(3) // Assuming 3 employees are on work
//                                 .map((name) => staffListItem(name))
//                                 .toList(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // BillsCard widget remains the same as in your provided code.
