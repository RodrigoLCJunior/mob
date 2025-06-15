import 'package:flutter/material.dart';
import 'package:midnight_never_end/ui/game_start/pages/game_start_screen.dart';

class DefeatMenuButton extends StatelessWidget {
  const DefeatMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const GameStartScreen()),
          (route) => false,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: const Text(
        'Voltar ao Menu',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
