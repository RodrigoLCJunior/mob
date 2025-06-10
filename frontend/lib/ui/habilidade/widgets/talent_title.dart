import 'package:flutter/material.dart';

class TalentTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final int level;
  final int cost;
  final VoidCallback? onPressed;
  final Animation<double>? glowAnimation;

  const TalentTile({
    super.key,
    required this.icon,
    required this.title,
    required this.level,
    required this.cost,
    this.onPressed,
    this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Cinzel",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                Text(
                  "Nível: $level | Custo: $cost",
                  style: const TextStyle(
                    fontFamily: "Cinzel",
                    fontSize: 14,
                    color: Colors.cyanAccent,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Melhorar",
              style: TextStyle(
                fontFamily: "Cinzel",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
