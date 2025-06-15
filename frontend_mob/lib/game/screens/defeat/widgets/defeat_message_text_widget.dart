import 'package:flutter/material.dart';

class DefeatMessageText extends StatelessWidget {
  const DefeatMessageText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Você foi derrotado pelo inimigo.',
      style: TextStyle(fontSize: 24, color: Colors.white),
    );
  }
}
