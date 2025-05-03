import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:midnight_never_end/models/usuario.dart';
import 'package:midnight_never_end/models/avatar.dart';
import 'package:flutter/material.dart';
import 'package:midnight_never_end/ui/components/damage_text_component.dart';
import 'package:midnight_never_end/ui/components/avatar/healthbar_component.dart';

class AvatarComponent extends PositionComponent {
  final Usuario usuario;
  final Avatar avatar;
  final RectangleComponent avatarRect;
  late TextComponent nameText;
  late HealthBarComponent healthBar;

  int currentHp;

  AvatarComponent(this.usuario, this.avatar, {required this.currentHp})
    : avatarRect = RectangleComponent(
        size: Vector2(120, 50),
        paint:
            Paint()
              ..color = const Color.fromARGB(255, 0, 0, 0)
              ..style = PaintingStyle.fill,
        children: [
          RectangleComponent(
            size: Vector2(120, 50),
            paint:
                Paint()
                  ..color = const Color(0xFF20D1DA)
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3,
          ),
          RectangleComponent(
            size: Vector2(120, 50),
            position: Vector2(3, 3),
            paint:
                Paint()
                  ..color = const Color(0x80000000)
                  ..style = PaintingStyle.fill,
            priority: -1,
          ),
        ],
      ),
      super(size: Vector2(120, 64));

  @override
  Future<void> onLoad() async {
    await add(avatarRect);

    nameText = TextComponent(
      text: usuario.nome.toUpperCase(),
      position: Vector2(60, 25),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF20D1DA),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Color(0xFF000000),
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
    await add(nameText);

    healthBar = HealthBarComponent(
      maxHp: avatar.hp,
      currentHp: currentHp,
      size: Vector2(100, 14),
      position: Vector2(10, 50),
    );
    await add(healthBar);
  }

  void takeDamage(int damage) {
    currentHp = (currentHp - damage).clamp(0, avatar.hp);
    healthBar.updateHp(currentHp);

    // Criar o texto flutuante de dano
    final damageText = DamageText(
      '-$damage',
      Vector2(60, 25), // Centro do avatar
    );
    add(damageText);
  }
}
