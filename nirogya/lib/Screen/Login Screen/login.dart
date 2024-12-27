import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nirogya/Screen/Login%20Screen/login_controller.dart';
import 'package:nirogya/Screen/Otp%20Screen/otp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode focusNode = FocusNode();
  String _countryCode = "91";
  TextEditingController phoneNumberController = TextEditingController();

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
                        "Welcome",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "Login in to continue",
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
                      // mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 150),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 50,
                                margin: const EdgeInsets.only(bottom: 1.5),
                                decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 2)),
                                ),
                                child: TextButton(
                                    onPressed: () {
                                      showCountryPicker(
                                          context: context,
                                          countryListTheme:
                                              const CountryListThemeData(
                                                  flagSize: 0),
                                          showPhoneCode: true,
                                          onSelect: (Country country) {
                                            setState(() {
                                              _countryCode = country.phoneCode;
                                            });
                                          });
                                    },
                                    child: Text(
                                      "+$_countryCode",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(118, 0, 0, 0)),
                                    )),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 50,
                                child: TextField(
                                  controller: phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  style: TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    hintText: "Mobile Number",
                                    hintStyle: TextStyle(
                                        color: Color.fromARGB(118, 0, 0, 0)),
                                    suffixIcon: Icon(
                                      Icons.phone,
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
                            ],
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
                            onPressed: () async {
                              Future<bool> result = LoginController().sendOtp(
                                  context,
                                  "+$_countryCode",
                                  phoneNumberController.text);
                              if (await result) {
                                print("OTP sent");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const OtpScreen()));
                              } else {
                                print("OTP not sent");
                              }
                            },
                            child: const Text(
                              "Send OTP",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),
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
