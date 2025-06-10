import 'package:flutter/material.dart';
import 'package:midnight_never_end/ui/game_start/widgets/glowing_icon_widget.dart';

class GameHeader extends StatelessWidget {
  final Animation<double> glowAnimation;
  final String userName;
  final VoidCallback onAccountOptionsTap;

  const GameHeader({
    super.key,
    required this.glowAnimation,
    required this.userName,
    required this.onAccountOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GlowingIcon(
              icon: Icons.person, // Changed to represent account options
              size: 24,
              onPressed: onAccountOptionsTap,
              tooltip: "Opções da Conta",
              glowAnimation: glowAnimation,
            ),
            const SizedBox(width: 8),
            Text(
              userName.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Cinzel",
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '${0}', // Placeholder; replace with coinAmount in GameStartScreen
              style: const TextStyle(
                fontFamily: "Cinzel",
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/icons/permCoin.png',
              width: 55,
              height: 55,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }
}
