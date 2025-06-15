import 'package:flutter/material.dart';

class VictoryMessageText extends StatelessWidget {
  const VictoryMessageText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Você derrotou o inimigo!',
      style: TextStyle(fontSize: 24, color: Colors.white),
    );
  }
}
