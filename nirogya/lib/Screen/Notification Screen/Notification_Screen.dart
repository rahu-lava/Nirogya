import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Example notifications and their details
  final List<Map<String, dynamic>> notifications = [
    {
      "title": "10 Medicines Expired",
      "details": [
        "Medicine A",
        "Medicine B",
        "Medicine C",
        "Medicine D",
        "Medicine E",
        "Medicine F",
        "Medicine G",
        "Medicine H",
        "Medicine I",
        "Medicine J",
      ],
    },
    {
      "title": "5 Low Stock Medicines",
      "details": [
        "Medicine X",
        "Medicine Y",
        "Medicine Z",
        "Medicine P",
        "Medicine Q"
      ],
    },
    {
      "title": "Pending Payments",
      "details": ["Invoice #1234", "Invoice #5678"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ExpansionTile(
              leading: Icon(Icons.notifications, color: Colors.red),
              title: Text(
                notification["title"],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: notification["details"]
                          .map<Widget>(
                            (detail) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                detail,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
