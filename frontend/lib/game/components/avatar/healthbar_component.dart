import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HealthBarComponent extends PositionComponent {
  final int maxHp;
  int currentHp;

  late RectangleComponent background;
  late RectangleComponent lifeBar;
  late RectangleComponent border;
  late TextComponent hpText;

  double _targetWidth;
  double _currentWidth;

  HealthBarComponent({
    required this.maxHp,
    required this.currentHp,
    required Vector2 size,
    Vector2? position,
  }) : _targetWidth = size.x - 4,
       _currentWidth = size.x - 4,
       super(size: size, position: position ?? Vector2.zero()) {
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    // Fundo preto
    background = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.black,
    );
    await add(background);

    // Barra de vida (vermelha)
    lifeBar = RectangleComponent(
      size: Vector2(_targetWidth, size.y - 4),
      position: Vector2(2, 2),
      paint:
          Paint()
            ..color = const Color.fromARGB(174, 45, 231, 3), // verde queimado
    );
    await add(lifeBar);

    // Borda cinza escura
    border = RectangleComponent(
      size: size,
      paint:
          Paint()
            ..color = const Color(0xFF444444)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
    );
    await add(border);

    // Texto HP atual / total
    hpText = TextComponent(
      text: '$currentHp / $maxHp',
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 1),
          ],
        ),
      ),
    );
    await add(hpText);

    _updateBarInstant();
  }

  void updateHp(int newHp) {
    currentHp = newHp.clamp(0, maxHp);
    _targetWidth = ((size.x - 4) * currentHp / maxHp).clamp(0, size.x - 4);
    hpText.text = '$currentHp / $maxHp';
  }

  void _updateBarInstant() {
    lifeBar.size.x = _targetWidth;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Animação suave da barra de vida
    if ((_currentWidth - _targetWidth).abs() > 0.5) {
      _currentWidth += (_targetWidth - _currentWidth) * 0.2;
      lifeBar.size.x = _currentWidth;
    } else {
      _currentWidth = _targetWidth;
      lifeBar.size.x = _currentWidth;
    }
  }
}
