import 'package:flutter/material.dart';

class VictoryTitleText extends StatelessWidget {
  const VictoryTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Vitória!',
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }
}
