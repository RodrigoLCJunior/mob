import 'package:flutter/material.dart';

class HabilidadesHeader extends StatelessWidget {
  const HabilidadesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "TALENTOS",
          style: TextStyle(
            fontFamily: "Cinzel",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Talentos podem fazer com que você\nfique mais forte permanentemente!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Cinzel",
            fontSize: 16,
            color: Colors.cyanAccent,
          ),
        ),
      ],
    );
  }
}
