import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nirogya/Views/Added%20Product%20Screen/added_product_list.dart';

class ConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      title: Text(
        "Is the QR code printed and applied?",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color(0xff920000),
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProductList()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Yes",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xff920000),
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "No",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}

// Function to show the dialog
void showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => ConfirmationDialog(),
  ).then((result) {
    if (result != null) {
      if (result) {
        // Handle "Yes" logic
        print("User selected Yes");
      } else {
        // Handle "No" logic
        print("User selected No");
      }
    }
  });
}
