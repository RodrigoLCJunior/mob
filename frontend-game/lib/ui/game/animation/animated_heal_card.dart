import 'package:flame/components.dart';
import 'package:midnight_never_end/models/card.dart';
import 'package:midnight_never_end/bloc/combat/combat_view_model.dart';
import 'package:midnight_never_end/ui/components/avatar/card_component.dart';
import 'package:flutter/material.dart';
class AnimatedHealCard extends PositionComponent with HasGameRef {
  final Cards card;
  final int cardIndex;
  final CombatViewModel viewModel;

  late CardComponent cardComponent;
  double _elapsed = 0;
  double _duration = 0.5;

  AnimatedHealCard({
    required this.card,
    required this.cardIndex,
    required this.viewModel,
    required Vector2 startPosition,
  }) {
    position = startPosition;
    size = Vector2.zero();
  }

  @override
  Future<void> onLoad() async {
    cardComponent = CardComponent(card, isDraggable: false);
    cardComponent.position = Vector2.zero();
    await add(cardComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    final t = (_elapsed / _duration).clamp(0.0, 1.0);
    final newOpacity = 1.0 - t;

    cardComponent.scale = Vector2.all(1.0 + 0.3 * t);

    // Aplica opacidade ao sprite
    cardComponent.imageComponent?.paint.color =
        cardComponent.imageComponent?.paint.color.withOpacity(newOpacity) ??
            const Color(0xFFFFFFFF).withOpacity(newOpacity);

    if (_elapsed >= _duration) {
      viewModel.playCard(card, cardIndex);
      removeFromParent();
    }
  }
}
