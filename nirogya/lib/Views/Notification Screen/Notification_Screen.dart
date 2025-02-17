import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:nirogya/Data/Added%20Medicine/added_medicine_repo.dart'; // Adjust the import based on your project structure

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedicineData();
  }

  Future<void> _fetchMedicineData() async {
    final addedMedicineRepo = AddedMedicineRepository();
    final addedMedicines = await addedMedicineRepo.getAllAddedMedicines();

    final now = DateTime.now();
    DateFormat format = DateFormat("dd/MM/yyyy");

    // Filter expired medicines
    final expiredMedicines = addedMedicines.where((medicine) {
      try {
        DateTime expiryDate =
            format.parse(medicine.finalMedicine.medicine.expiryDate);
        return expiryDate.isBefore(now);
      } catch (e) {
        print(
            "Error parsing date: ${medicine.finalMedicine.medicine.expiryDate}");
        return false;
      }
    }).toList();

    // Filter low stock medicines
    final lowStockMedicines = addedMedicines.where((medicine) {
      return medicine.finalMedicine.medicine.quantity < 5;
    }).toList();

    // Build notifications
    setState(() {
      notifications = [
        if (expiredMedicines.isNotEmpty)
          {
            "title": "${expiredMedicines.length} Medicines Expired",
            "details": expiredMedicines
                .map((medicine) =>
                    "${medicine.finalMedicine.medicine.productName} (Expiry: ${medicine.finalMedicine.medicine.expiryDate})")
                .toList(),
          },
        if (lowStockMedicines.isNotEmpty)
          {
            "title": "${lowStockMedicines.length} Low Stock Medicines",
            "details": lowStockMedicines
                .map((medicine) =>
                    "${medicine.finalMedicine.medicine.productName} (Stock: ${medicine.finalMedicine.medicine.quantity})")
                .toList(),
          },
      ];
      isLoading = false;
    });
  }

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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(
                  child: Text(
                    "No notifications available.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
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
                                children: notification["details"]
                                    .map<Widget>(
                                      (detail) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0),
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
