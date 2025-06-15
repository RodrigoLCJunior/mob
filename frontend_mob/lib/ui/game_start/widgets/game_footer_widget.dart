import 'package:flutter/material.dart';
import 'package:midnight_never_end/ui/game_start/widgets/glowing_icon_widget.dart';

class GameFooter extends StatelessWidget {
  final Animation<double> glowAnimation;
  final Future<void> Function(BuildContext)
  onHabilidadesPressed; // Atualizado para Future<void>
  final Future<void> Function(BuildContext)
  onSettingsPressed; // Atualizado para Future<void>

  const GameFooter({
    super.key,
    required this.glowAnimation,
    required this.onHabilidadesPressed,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GlowingIcon(
            icon: Icons.star,
            size: 30,
            onPressed:
                () =>
                    onHabilidadesPressed(context), // Chama a função assíncrona
            tooltip: "Habilidades",
            glowAnimation: glowAnimation,
          ),
          GlowingIcon(
            icon: Icons.settings,
            size: 30,
            onPressed:
                () => onSettingsPressed(context), // Chama a função assíncrona
            tooltip: "Configurações",
            glowAnimation: glowAnimation,
          ),
        ],
      ),
    );
  }
}
