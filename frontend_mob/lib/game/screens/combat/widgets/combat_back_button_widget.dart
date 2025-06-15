import 'package:flutter/material.dart';
import 'package:midnight_never_end/game/screens/combat/widgets/combat_exit_dialog_widget.dart';
import 'package:midnight_never_end/ui/game_start/pages/game_start_screen.dart';

class CombatBackButton extends StatelessWidget {
  final bool isPlayerTurn;

  const CombatBackButton({super.key, required this.isPlayerTurn});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final turnColor =
        isPlayerTurn ? const Color(0xFF155250) : const Color(0xFF2A1A3D);

    return Positioned(
      top: screenHeight * 0.05,
      left: screenHeight * 0.02,
      child: Container(
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
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          iconSize: screenHeight * 0.035,
          tooltip: 'Voltar ao menu',
          onPressed: () async {
            final shouldLeave = await showDialog<bool>(
              context: context,
              builder: (context) => CombatExitDialog(turnColor: turnColor),
            );

            if (shouldLeave == true && context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const GameStartScreen()),
              );
            }
          },
        ),
      ),
    );
  }
}
