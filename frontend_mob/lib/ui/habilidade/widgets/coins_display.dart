import 'package:flutter/material.dart';

class CoinsDisplay extends StatelessWidget {
  final int coins;

  const CoinsDisplay({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/permCoin.png',
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 10),
        Text(
          '$coins',
          style: const TextStyle(
            fontFamily: "Cinzel",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
      ],
    );
  }
}
