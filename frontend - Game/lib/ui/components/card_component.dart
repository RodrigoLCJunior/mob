import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:midnight_never_end/models/card.dart';

class CardComponent extends PositionComponent with DragCallbacks {
  final Cards card;
  final Function(CardComponent)? onDragEndCallback;
  final RectangleComponent cardRect;
  late TextComponent nameText;
  late TextComponent damageText;
  bool _isDragging = false;
  Vector2? _originalPosition;
  final Paint _defaultPaint;
  final Paint _draggingPaint;
  bool isDraggable; // Removido o 'final' para permitir alterações

  late double originalAngle;
  late Vector2 originalScale;

  CardComponent(this.card, {this.onDragEndCallback, this.isDraggable = true})
    : _defaultPaint =
          Paint()
            ..color = const Color(0xFF2F2F2F)
            ..style = PaintingStyle.fill,
      _draggingPaint =
          Paint()
            ..color = const Color(0xFF4A4A4A)
            ..style = PaintingStyle.fill,
      cardRect = RectangleComponent(
        size: Vector2(60, 90), // Tamanho reduzido
        paint:
            Paint()
              ..color = const Color(0xFF2F2F2F)
              ..style = PaintingStyle.fill,
        children: [
          RectangleComponent(
            size: Vector2(60, 90),
            paint:
                Paint()
                  ..color = const Color(0xFFDAA520)
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2,
          ),
          RectangleComponent(
            size: Vector2(60, 90),
            position: Vector2(2, 2), // Sombra ajustada para o novo tamanho
            paint:
                Paint()
                  ..color = const Color(0x80000000)
                  ..style = PaintingStyle.fill,
            priority: -1,
          ),
        ],
      ),
      super(size: Vector2(60, 90));

  Vector2 get originalPosition => _originalPosition ?? position;

  void setOriginalPosition(Vector2 newPosition) {
    _originalPosition = newPosition.clone();
  }

  @override
  Future<void> onLoad() async {
    await add(cardRect);

    nameText = TextComponent(
      text: card.nome.toUpperCase(),
      position: Vector2(30, 30), // Ajustado para o novo tamanho (60/2, 90/3)
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 12, // Tamanho da fonte reduzido
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

    damageText = TextComponent(
      text: 'DANO: ${card.damage}',
      position: Vector2(30, 70), // Ajustado para o novo tamanho (60/2, 90*0.78)
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFF4500),
          fontSize: 10, // Tamanho da fonte reduzido
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
    await add(damageText);

    _originalPosition = position.clone();
    originalAngle = angle;
    originalScale = scale.clone();
    print(
      'CardComponent loaded: ${card.nome} at position $position (card_component.dart)',
    );
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (!isDraggable || !containsLocalPoint(event.localPosition)) return;

    _isDragging = true;
    event.handled = true;
    priority = 100;
    cardRect.paint = _draggingPaint;
    scale = Vector2.all(1.2);
    angle = 0;
    print(
      'Drag started for ${card.nome} at local position ${event.localPosition}, scale=$scale, angle=$angle (card_component.dart)',
    );
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_isDragging) {
      position += event.localDelta;
      angle = 0;
      event.handled = true;
      print(
        'Drag update for ${card.nome}: new position=$position (card_component.dart)',
      );
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (_isDragging) {
      _isDragging = false;
      cardRect.paint = _defaultPaint;
      scale = originalScale.clone();
      angle = originalAngle;
      priority = 0;
      if (onDragEndCallback != null) {
        onDragEndCallback!(this);
      }
      event.handled = true;
      print(
        'Drag ended for ${card.nome} at position $position, scale=$scale, angle=$angle (card_component.dart)',
      );
    }
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    _isDragging = false;
    cardRect.paint = _defaultPaint;
    scale = originalScale.clone();
    angle = originalAngle;
    priority = 0;
    position = _originalPosition!.clone();
    event.handled = true;
    print(
      'Drag cancelled for ${card.nome}, scale=$scale, angle=$angle (card_component.dart)',
    );
  }
}
