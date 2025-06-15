import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:midnight_never_end/game/game/combat/combat_game.dart';

class CombatGameWidget extends StatelessWidget {
  final CombatGame game;

  const CombatGameWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: GameWidget(game: game),
        );
      },
    );
  }
}
