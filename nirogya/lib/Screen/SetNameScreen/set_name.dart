import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nirogya/Screen/Home/home.dart';
import 'package:nirogya/Screen/SetNameScreen/set_name_controller.dart';

class SetName extends StatefulWidget {
  const SetName({super.key});

  @override
  State<SetName> createState() => _SetNameState();
}

void _setUserName(BuildContext context, String name) async {
  Future<bool> result = setNameController().setUsername(context, name);
  if (await result) {
    // Navigate to the next screen
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  } else {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to set username"),
      ),
    );
  }
}

class _SetNameState extends State<SetName> {
  bool _isChecked = false;
  TextEditingController nameController = TextEditingController();

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
                      color: Colors.white,
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
                        "Enter OTP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "OTP has been send to +91987****321",
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            child: TextField(
                              controller: nameController,
                              cursorColor: const Color(0xff920000),
                              keyboardType: TextInputType.name,
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter,
                                LengthLimitingTextInputFormatter(20),
                              ],
                              style: TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                hintText: "Your Name",
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(118, 0, 0, 0)),
                                suffixIcon: Icon(
                                  Icons.portrait_sharp,
                                  color: Color(0xff920000),
                                ),
                                // Customizing the bottom border
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors
                                        .grey, // Change to your desired color
                                    width:
                                        2.0, // Adjust the width of the bottom border
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors
                                        .grey, // Color when the field is focused
                                    width:
                                        2.0, // Adjust the width of the bottom border when focused
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xff920000),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextButton(
                            onPressed: () {
                              print("your Name : " + nameController.text);
                              _setUserName(
                                  context, (nameController.text).trim());
                            },
                            child: const Text(
                              "Proceed",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),
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
                              onTap: () {
                                // Handle Terms & Conditions click
                              },
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
          Positioned(
            bottom: 20, // Adjust as needed
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/nirogya_logo_short.png', // Replace with your logo path
                width: 100, // Adjust size as needed
              ),
            ),
          )
        ]),
      ),
    );
  }
}
