import 'package:flutter/material.dart';

class CombatPassTurnButton extends StatelessWidget {
  final bool isPlayerTurn;
  final VoidCallback onPassTurn;

  const CombatPassTurnButton({
    super.key,
    required this.isPlayerTurn,
    required this.onPassTurn,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isEnabled = isPlayerTurn; // Simplified without animation check

    return Positioned(
      bottom: screenHeight * 0.05,
      right: screenHeight * 0.02,
      child: Container(
        decoration: BoxDecoration(
          color:
              isEnabled
                  ? const Color(0xFF155250)
                  : Colors.grey.withOpacity(0.5),
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
        child: ElevatedButton(
          onPressed: isEnabled ? onPassTurn : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: screenHeight * 0.0125,
              vertical: screenHeight * 0.0075,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            elevation: 0,
          ),
          child: Text(
            'Passar Turno',
            style: TextStyle(
              color: isEnabled ? Colors.white : Colors.white.withOpacity(0.5),
              fontSize: screenHeight * 0.011,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
