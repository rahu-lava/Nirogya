import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nirogya/Data/Added Medicine/added_medicine_repo.dart'; // Import the Added Medicine repository
import 'package:nirogya/Model/Scanned Medicine/scanned_medicine.dart'; // Import the ScannedMedicine model
import '../Views/Stock info Screen/stock_info_screen.dart';

class SearchStockWidget extends StatefulWidget {
  @override
  _SearchStockWidgetState createState() => _SearchStockWidgetState();
}

class _SearchStockWidgetState extends State<SearchStockWidget> {
  TextEditingController _searchController = TextEditingController();
  final AddedMedicineRepository _addedMedicineRepo =
      AddedMedicineRepository(); // Added Medicine repository
  List<ScannedMedicine> _addedMedicines = []; // List of added medicines
  List<ScannedMedicine> _filteredMedicines = []; // Filtered list of medicines

  @override
  void initState() {
    super.initState();
    _loadAddedMedicines(); // Load added medicines when the widget is initialized
  }

  // Fetch added medicines from the repository
  Future<void> _loadAddedMedicines() async {
    final medicines = await _addedMedicineRepo.getAllAddedMedicines();

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        _addedMedicines = medicines;
        _filteredMedicines =
            medicines; // Initialize filtered list with all medicines
      });
    }
  }

  // Filter medicines based on search query
  void _filterMedicines(String query) {
    setState(() {
      _filteredMedicines = _addedMedicines
          .where((medicine) => medicine.finalMedicine.medicine.productName
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            child: TextField(
              controller: _searchController,
              cursorColor: Color(0xff920000), // Red for focus
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter,
                LengthLimitingTextInputFormatter(15),
              ],
              onChanged: _filterMedicines,
              decoration: InputDecoration(
                hintText: 'Search Stock...',
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xff920000), // Always red
                ),
                // suffixIcon: Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     IconButton(
                //       icon: Icon(
                //         Icons.mic,
                //         color: Color(0xff920000), // Always red
                //       ),
                //       onPressed: () {
                //         // Handle microphone icon action
                //       },
                //     ),
                //     IconButton(
                //       icon: Icon(
                //         Icons.filter_list,
                //         color: Color(0xff920000), // Always red
                //       ),
                //       onPressed: () {
                //         // Handle filter icon action
                //       },
                //     ),
                //   ],
                // ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15.0), // Set border radius
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15.0), // Set border radius
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15.0), // Set border radius
                  borderSide: BorderSide(color: Color(0xff920000)),
                ),
              ),
            ),
          ),
        ),

        // Medicine List
        Expanded(
          child: ListView.builder(
            itemCount: _filteredMedicines.length,
            itemBuilder: (context, index) {
              final medicine = _filteredMedicines[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to Stock Info Screen and pass the selected medicine
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StockInfoScreen(medicine: medicine),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border(
                        right: BorderSide(
                          color: const Color.fromARGB(
                              255, 204, 28, 16), // Red border for stock
                          width: 4.5,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            // Medicine Image
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255)
                                    .withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:
                                  // Image.file(
                                  //   "assets/images/no_preview_img.webp",
                                  //   height: 100,
                                  //   width: 100,
                                  // ),
                                  Image.file(
                                File(
                                    medicine.finalMedicine.medicine.imagePath!),
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/images/no_preview_img.webp", // Fallback image
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.contain,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 10),

                            // Medicine Details
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Medicine Name
                                  Container(
                                    child: Text(
                                      medicine
                                          .finalMedicine.medicine.productName,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),

                                  // Expiry, Quantity, and Batch
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Expiry: ${medicine.finalMedicine.medicine.expiryDate}",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              "Quantity: ${medicine.finalMedicine.medicine.quantity}",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              "Batch: ${medicine.finalMedicine.medicine.batch}",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(height: 3),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Text(
                                            "₹${medicine.finalMedicine.medicine.price}",
                                            style: TextStyle(fontSize: 24),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
