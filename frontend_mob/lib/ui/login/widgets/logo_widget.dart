import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/rewalker.png",
      width: 300,
      height: 200,
      fit: BoxFit.contain,
    );
  }
}
