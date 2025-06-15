import 'package:flutter/material.dart';

class CombatTurnIndicator extends StatelessWidget {
  final bool isPlayerTurn;

  const CombatTurnIndicator({super.key, required this.isPlayerTurn});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final turnColor =
        isPlayerTurn ? const Color(0xFF155250) : const Color(0xFF2A1A3D);

    return Positioned(
      top: screenHeight * 0.05,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenHeight * 0.02,
            vertical: screenHeight * 0.015,
          ),
          decoration: BoxDecoration(
            color: turnColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            isPlayerTurn ? 'Turno do Jogador' : 'Turno do Inimigo',
            style: TextStyle(
              color: Colors.white,
              fontSize: screenHeight * 0.025,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(
                  color: Colors.black38,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
