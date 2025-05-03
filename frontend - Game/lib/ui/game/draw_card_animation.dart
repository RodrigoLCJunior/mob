import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:midnight_never_end/models/card.dart';
import 'package:midnight_never_end/ui/components/card_component.dart';

class DrawCardAnimation extends CardComponent {
  final Vector2 targetPosition;
  final Vector2 startPosition;
  final double duration;
  double elapsedTime = 0.0;
  final double startAngle;
  final double endAngle;
  final VoidCallback? onAnimationComplete;

  DrawCardAnimation({
    required Cards card,
    required this.startPosition,
    required this.targetPosition,
    this.duration = 0.6,
    this.startAngle = -math.pi / 2,
    this.endAngle = 0.0,
    this.onAnimationComplete,
  }) : super(card, isDraggable: false) {
    position = startPosition.clone();
    angle = startAngle;
    scale = Vector2.all(0.3);
    priority = 101; // Acima das cartas normais
  }

  @override
  void update(double dt) {
    super.update(dt);
    elapsedTime += dt;
    final t = (elapsedTime / duration).clamp(0.0, 1.0);

    position = Vector2(
      startPosition.x + (targetPosition.x - startPosition.x) * t,
      startPosition.y + (targetPosition.y - startPosition.y) * t,
    );

    angle = startAngle + (endAngle - startAngle) * t;
    final scaleFactor = 0.3 + 0.7 * t;
    scale = Vector2.all(scaleFactor);

    if (t >= 1.0) {
      onAnimationComplete?.call();
      if (isMounted) {
        removeFromParent();
      }
    }
  }
}
