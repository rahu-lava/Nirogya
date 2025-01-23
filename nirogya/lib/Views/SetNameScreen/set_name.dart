import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import '../Home/home.dart';
import 'set_name_controller.dart';

class SetName extends StatefulWidget {
  const SetName({super.key});

  @override
  State<SetName> createState() => _SetNameState();
}

void _setUserName(BuildContext context, String name) async {
  Future<bool> result = setNameController().setUsername(context, name);
  if (await result) {
    // Navigate to the next screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  } else {
    // Show error message
    ToastService.showErrorToast(context,
        length: ToastLength.medium,  
        expandedHeight: 100,
        message: "Failed to set username");
  }
}

class _SetNameState extends State<SetName> {
  bool _isChecked = false;
  TextEditingController nameController = TextEditingController();

  void _showTermsAndConditions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Terms and Conditions",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              "1. The user must provide accurate information.\n"
              "2. By accepting these terms, you agree to abide by the app's rules.\n"
              "3. Any misuse of the application will result in account termination.\n"
              "4. We respect your privacy and ensure your data is safe.\n",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isChecked = true; // Accept the terms
                });
                Navigator.pop(context); // Close the bottom sheet
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff920000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Accept Terms",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff920000),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: Color(0xff920000)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xff920000),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter Your Name",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "Please set your username to continue",
                        style: TextStyle(
                            color: Color.fromARGB(184, 255, 255, 255),
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(70)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 150),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            controller: nameController,
                            cursorColor: const Color(0xff920000),
                            keyboardType: TextInputType.name,
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter,
                              LengthLimitingTextInputFormatter(20),
                            ],
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              hintText: "Your Name",
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(118, 0, 0, 0)),
                              suffixIcon: Icon(
                                Icons.portrait_sharp,
                                color: Color(0xff920000),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        GestureDetector(
                          onTap: () {
                            if (!_isChecked) {
                              // Show warning toast if terms are not accepted
                              ToastService.showWarningToast(
                                context,
                                length: ToastLength.medium,
                                expandedHeight: 100,
                                message:
                                    "Please accept the Terms and Conditions",
                              );
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _isChecked
                                  ? const Color(0xff920000)
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextButton(
                              onPressed: _isChecked
                                  ? () {
                                      print(
                                          "Your Name: ${nameController.text}");
                                      _setUserName(
                                          context, nameController.text.trim());
                                    }
                                  : null,
                              child: const Text(
                                "Proceed",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              checkColor: Colors.red,
                              activeColor: Colors.white,
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value ?? false;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: _showTermsAndConditions,
                              child: RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'I accept the ',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: 'Terms & Conditions',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
