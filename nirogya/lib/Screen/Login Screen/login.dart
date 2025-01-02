import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:nirogya/Screen/Login%20Screen/login_controller.dart';
import 'package:nirogya/Screen/Otp%20Screen/otp.dart';
import 'package:nirogya/Widget/loading_widget.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode focusNode = FocusNode();
  String _countryCode = "91";
  TextEditingController phoneNumberController = TextEditingController();

  // Lottie animation state
  bool _isLoading = false;

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
                                          favorite: const ['+91', 'IN'],
                                          countryListTheme:
                                              const CountryListThemeData(
                                            flagSize: 25,
                                          ),
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
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    hintText: "Mobile Number",
                                    hintStyle: TextStyle(
                                        color: Color.fromARGB(118, 0, 0, 0)),
                                    suffixIcon: Icon(
                                      Icons.phone,
                                      color: Color(0xff920000),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2.0,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2.0,
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
                              setState(() {
                                _isLoading = true;
                              });

                              Future<bool> result = LoginController().sendOtp(
                                  context,
                                  "+$_countryCode",
                                  phoneNumberController.text);

                              if (await result) {
                                ToastService.showSuccessToast(
                                  context,
                                  length: ToastLength.medium,
                                  message: "OTP sent successfully!",
                                );
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const OtpScreen()),
                                  (route) => false,
                                );
                              } else {
                                ToastService.showErrorToast(
                                  context,
                                  length: ToastLength.medium,
                                  message: "Failed to send OTP. Try again!",
                                );
                              }

                              setState(() {
                                _isLoading = false;
                              });
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
          if (_isLoading) const CommonLottieWidget(),
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
