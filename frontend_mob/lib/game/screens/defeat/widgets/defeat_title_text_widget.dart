import 'package:flutter/material.dart';

class DefeatTitleText extends StatelessWidget {
  const DefeatTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Derrota!',
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }
}
