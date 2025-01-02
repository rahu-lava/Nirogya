import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CommonLottieWidget extends StatelessWidget {
  const CommonLottieWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark background
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
          ),
        ),
        // Centered animation with white circular background
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff920000), width: 2),
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              Lottie.asset(
                'assets/animation/nir_anim.json', // Replace with your animation path
                width: 65,
                height: 65,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
