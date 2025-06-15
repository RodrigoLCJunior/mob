import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:midnight_never_end/domain/entities/avatar/avatar_entity.dart';
import 'package:midnight_never_end/domain/entities/user/user_entity.dart';
import 'package:midnight_never_end/game/components/avatar/healthbar_component.dart';
import 'package:midnight_never_end/game/components/geral/textos/damage_text_component.dart';
import 'package:midnight_never_end/game/components/geral/textos/heal_text_component.dart';

class AvatarComponent extends PositionComponent {
  final Usuario usuario;
  final Avatar avatar;
  final SpriteComponent avatarRect; // Alterado para SpriteComponent
  late TextComponent nameText;
  late HealthBarComponent healthBar;
  late SpriteComponent poisonIcon;
  late TextComponent poisonTurnText;

  int currentHp;

  AvatarComponent(this.usuario, this.avatar, {required this.currentHp})
    : avatarRect = SpriteComponent(size: Vector2(120, 50)),
      super(size: Vector2(120, 64));

  @override
  Future<void> onLoad() async {
    // Carregar a imagem namePlacer.png
    final sprite = await Sprite.load('namePlacer.png');
    avatarRect.sprite = sprite;
    avatarRect.size = Vector2(120, 50); // Garantir o tamanho correto

    await add(avatarRect);

    nameText = TextComponent(
      text: usuario.nome.toUpperCase(),
      position: Vector2(60, 25),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF), // Cor branca para o nome
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

    poisonIcon =
        SpriteComponent()
          ..sprite = await Sprite.load('../icons/poisonIcon.png')
          ..size = Vector2(35, 35)
          ..position = Vector2(
            healthBar.position.x + healthBar.size.x + 5, // ajuste lateral
            healthBar.position.y + (healthBar.size.y - 35) / 2,
          )
          ..opacity = 0.0;
    await add(poisonIcon);

    poisonTurnText = TextComponent(
      text: null,
      position: Vector2(
        poisonIcon.position.x + poisonIcon.size.x + 2,
        poisonIcon.position.y + 5,
      ),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(0, 255, 255, 255),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2),
          ],
        ),
      ),
    );
    await add(poisonTurnText);
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

  void heal(int amount) {
    currentHp = (currentHp + amount).clamp(0, avatar.hp);
    healthBar.updateHp(currentHp);

    final healText = HealText('+$amount', Vector2(60, 25));
    add(healText);
  }

  void updatePoisonIcon({required int poisonTurns}) {
    poisonIcon.opacity = poisonTurns > 0 ? 1.0 : 0.0;
    poisonTurnText.text = poisonTurns.toString();

    final double opacity = poisonTurns > 0 ? 1.0 : 0.0;
    final Color visibleColor = Colors.white.withOpacity(opacity);

    poisonTurnText.textRenderer = TextPaint(
      style: TextStyle(
        color: visibleColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        shadows:
            poisonTurns != 0
                ? const [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ]
                : const [],
      ),
    );
  }
}
