import 'package:flutter/material.dart';

class CombatExitDialog extends StatelessWidget {
  final Color turnColor;

  const CombatExitDialog({super.key, required this.turnColor});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      title: const Text('Sair do combate?'),
      content: const Text(
        'Tem certeza que deseja sair? Seu progresso será perdido.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            backgroundColor: turnColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: screenHeight * 0.02,
              vertical: screenHeight * 0.01,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            backgroundColor: turnColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: screenHeight * 0.02,
              vertical: screenHeight * 0.01,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text('Sair'),
        ),
      ],
    );
  }
}
