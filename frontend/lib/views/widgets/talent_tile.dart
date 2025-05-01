import 'package:flutter/material.dart';

class TalentTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final int level;
  final int cost;
  final VoidCallback onPressed;
  final Animation<double>? glowAnimation;

  const TalentTile({
    super.key,
    required this.icon,
    required this.title,
    required this.level,
    required this.cost,
    required this.onPressed,
    this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    Widget tile = Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black, // Fundo preto
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.cyanAccent, size: 30), // Ícone em azul
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent, // Texto em azul
                      fontFamily: "Cinzel",
                    ),
                  ),
                  Text(
                    "Nível: $level",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.cyanAccent, // Texto em azul
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.cyanAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Melhorar ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Cinzel",
                    ),
                  ),
                  Text(
                    "$cost",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Cinzel",
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset(
                    'assets/icons/permCoin.png',
                    width: 25,
                    height: 25,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (glowAnimation != null) {
      return AnimatedBuilder(
        animation: glowAnimation!,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(
                  glowAnimation!.value * 0.5,
                ),
                width: 2,
              ),
            ),
            child: child,
          );
        },
        child: tile,
      );
    }

    return tile;
  }
}
