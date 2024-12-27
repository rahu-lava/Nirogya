import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nirogya/Auth/auth_provider.dart';
import 'package:nirogya/Screen/Home/home.dart';
import 'package:nirogya/Screen/Otp%20Screen/otp_controller.dart';
import 'package:nirogya/Screen/SetNameScreen/set_name.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _start = 59; // Set your initial countdown time in seconds
  bool _isTimerFinished = false; // Flag to track if the timer is finished
  String _otp = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimer(); // Start the countdown timer
  }

  // Function to start the countdown timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          _isTimerFinished = true; // Set the flag to true when timer finishes
          _timer.cancel(); // Stop the timer
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  // Function to resend OTP when the timer finishes
  void _resendOtp(String number) async {
    if (_isTimerFinished) {
      // Resend OTP logic here
      Future<bool> result = OtpController().onResendOtp(context, number);
      if (await result) {
      } else {}
      print("Resending OTP...");
      setState(() {
        _start = 59; // Reset the timer
        _isTimerFinished = false; // Reset the flag
      });
      _startTimer(); // Start the countdown again
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer
        .cancel(); // Make sure to cancel the timer when the widget is disposed
  }

  Future<void> sendOtp(value) async {
    Future<bool> result = OtpController().onVerifyOtp(context, value);
    if (await result) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SetName()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid OTP"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = context.read<AuthProvider>();
    String number = authProvider.number;
    String maskedNumber = OtpController().morphPhoneNumber(number);

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enter OTP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "OTP has been send to $maskedNumber",
                        style: const TextStyle(
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
                          child: Pinput(
                            length: 6,
                            onCompleted: (value) {
                              _otp = value;
                              sendOtp(value);
                            },
                            defaultPinTheme: PinTheme(
                                width: 40,
                                height: 50,
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey))),
                            focusedPinTheme: PinTheme(
                                width: 40,
                                height: 50,
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff920000),
                                        width: 2))),
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
                              if (_otp.length == 6) {
                                sendOtp(_otp);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please enter a valid OTP"),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              "Verify",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: _isTimerFinished
                              ? () => {_resendOtp(number)}
                              : null, // Only allow tap when the timer finishes
                          child: Text(
                            _isTimerFinished
                                ? "Resend OTP"
                                : "Resend OTP in 00:${_start.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              color: _isTimerFinished
                                  ? const Color(0xff920000)
                                  : Colors.grey,
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              decoration: _isTimerFinished
                                  ? TextDecoration.underline
                                  : null, // Underline only when timer finishes
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
