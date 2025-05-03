import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:midnight_never_end/models/card.dart';

class EnemyCardComponent extends PositionComponent {
  final Cards card;
  final RectangleComponent cardBack;
  Vector2? _originalPosition;
  late double originalAngle;
  late Vector2 originalScale;

  EnemyCardComponent(this.card, {Vector2? initialPosition})
    : cardBack = RectangleComponent(
        size: Vector2(60, 90),
        paint:
            Paint()
              ..color = const Color(0xFF555555) // Cor do verso
              ..style = PaintingStyle.fill,
        children: [
          TextComponent(
            text: 'VERSO',
            position: Vector2(30, 45),
            anchor: Anchor.center,
            textRenderer: TextPaint(
              style: const TextStyle(
                color: Color(0xFF000000),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      super(
        size: Vector2(60, 90),
        position: initialPosition ?? Vector2.zero(),
      ) {
    _originalPosition = initialPosition?.clone() ?? position.clone();
  }

  Vector2 get originalPosition => _originalPosition ?? position;

  void setOriginalPosition(Vector2 newPosition) {
    _originalPosition = newPosition.clone();
  }

  @override
  Future<void> onLoad() async {
    // Adicionar apenas o verso da carta
    await add(cardBack);

    originalAngle = angle;
    originalScale = scale.clone();
    print(
      'EnemyCardComponent loaded: ${card.nome} at position $position (enemy_card_component.dart)',
    );
  }
}
