import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:midnight_never_end/models/usuario.dart';
import 'package:midnight_never_end/models/avatar.dart';

// Classe para o texto flutuante de dano (reutilizada do InimigoComponent)
class DamageText extends TextComponent {
  double lifetime = 0.8; // Duração total da animação (em segundos)
  double elapsedTime = 0.0;
  final double initialY;
  double opacity = 1.0;

  DamageText(String text, Vector2 position)
    : initialY = position.y,
      super(
        text: text,
        position: position,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFFF4500),
            fontSize: 16,
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

  @override
  void update(double dt) {
    super.update(dt);
    elapsedTime += dt;

    // Calcular a fração do tempo decorrido (0 a 1)
    final t = (elapsedTime / lifetime).clamp(0.0, 1.0);

    // Mover o texto para cima (30 pixels ao longo da animação)
    position.y = initialY - 30 * t;

    // Reduzir a opacidade gradualmente
    opacity = 1.0 - t;
    textRenderer = TextPaint(
      style: TextStyle(
        color: Color(0xFFFF4500).withOpacity(opacity),
        fontSize: 16,
        fontWeight: FontWeight.bold,
        shadows: const [
          Shadow(color: Color(0xFF000000), offset: Offset(1, 1), blurRadius: 2),
        ],
      ),
    );

    // Remover o texto quando a animação terminar
    if (elapsedTime >= lifetime) {
      removeFromParent();
    }
  }
}

class AvatarComponent extends PositionComponent {
  final Usuario usuario;
  final Avatar avatar;
  final RectangleComponent avatarRect;
  late RectangleComponent lifeBar;
  late RectangleComponent lifeBarBorder;
  late TextComponent nameText;
  late TextComponent hpText;
  int currentHp;
  double _targetLifeBarWidth = 90.0;

  AvatarComponent(this.usuario, this.avatar, {required this.currentHp})
    : avatarRect = RectangleComponent(
        size: Vector2(120, 50),
        paint:
            Paint()
              ..color = const Color(0xFF006400)
              ..style = PaintingStyle.fill,
        children: [
          RectangleComponent(
            size: Vector2(120, 50),
            paint:
                Paint()
                  ..color = const Color(0xFFDAA520)
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
    print('AvatarComponent - onLoad called (avatar_component.dart)');

    await add(avatarRect);

    nameText = TextComponent(
      text: usuario.nome.toUpperCase(),
      position: Vector2(60, 25),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
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

    lifeBarBorder = RectangleComponent(
      size: Vector2(100, 14),
      paint:
          Paint()
            ..color = const Color(0xFF000000)
            ..style = PaintingStyle.fill,
      position: Vector2(10, 50),
    );
    await add(lifeBarBorder);

    lifeBar = RectangleComponent(
      size: Vector2(90, 8),
      paint:
          Paint()
            ..shader = const LinearGradient(
              colors: [Color(0xFF32CD32), Color(0xFF006400)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(const Rect.fromLTWH(0, 0, 90, 8)),
      position: Vector2(15, 53),
      anchor: Anchor.topLeft,
    );
    await add(lifeBar);

    hpText = TextComponent(
      text: '$currentHp',
      position: Vector2(15 + (90 - 15) / 2, 53),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 10,
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
    await add(hpText);

    updateLifeBar();
  }

  void updateLifeBar() {
    final fullWidth = 90.0;
    final currentWidth = (currentHp / avatar.hp) * fullWidth;
    _targetLifeBarWidth = currentWidth.clamp(0, fullWidth);

    lifeBar.paint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF32CD32), Color(0xFF006400)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, _targetLifeBarWidth, 8));
  }

  void takeDamage(int damage) {
    final newHp = (currentHp - damage).clamp(0, avatar.hp);
    currentHp = newHp;
    hpText.text = '$currentHp';

    // Adicionar texto flutuante de dano
    final damageText = DamageText(
      '-$damage',
      Vector2(60, 25),
    ); // Centro do avatar
    add(damageText);

    // Atualizar a barra de vida
    updateLifeBar();
  }

  @override
  void update(double dt) {
    super.update(dt);
    hpText.text = '$currentHp';

    // Animar a barra de vida suavemente
    final currentWidth = lifeBar.size.x;
    if ((currentWidth - _targetLifeBarWidth).abs() > 0.1) {
      final newWidth =
          currentWidth + (_targetLifeBarWidth - currentWidth) * 0.1;
      lifeBar.size.x = newWidth;
      lifeBar.position = Vector2(15, 53);
      hpText.position = Vector2(15 + newWidth / 2, 53);
    }
  }
}
