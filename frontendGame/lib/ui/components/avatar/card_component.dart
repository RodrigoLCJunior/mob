/// Este arquivo define a classe `CardComponent`, responsável por renderizar
/// uma carta do jogador (avatar) no jogo de combate baseado em turnos usando o Flame.
///
/// Principais responsabilidades:
/// - Renderiza a frente da carta com base no modelo `Cards`.
/// - Suporta interação de arrastar (quando `isDraggable` é verdadeiro).
/// - Define um tamanho grande para as cartas, inspirado no jogo Night of the Full Moon,
///   com largura de 15% da tela e proporção 2:3 (largura:altura).
/// - Ajusta os elementos visuais (borda, sombra, textos) para o novo tamanho.
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:midnight_never_end/models/card.dart';

class CardComponent extends PositionComponent with DragCallbacks, HasGameRef {
  final Cards card;
  final Function(CardComponent)? onDragEndCallback;
  final RectangleComponent cardRect;
  late TextComponent nameText;
  late TextComponent damageText;
  bool _isDragging = false;
  Vector2? _originalPosition;
  final Paint _defaultPaint;
  final Paint _draggingPaint;
  bool isDraggable;

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
        paint:
            Paint()
              ..color = const Color(0xFF2F2F2F)
              ..style = PaintingStyle.fill,
        children: [
          RectangleComponent(
            paint:
                Paint()
                  ..color = const Color(0xFFDAA520)
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2,
          ),
          RectangleComponent(
            position: Vector2(2, 2),
            paint:
                Paint()
                  ..color = const Color(0x80000000)
                  ..style = PaintingStyle.fill,
            priority: -1,
          ),
        ],
      ),
      super();

  Vector2 get originalPosition => _originalPosition ?? position;

  void setOriginalPosition(Vector2 newPosition) {
    _originalPosition = newPosition.clone();
  }

  void _setSizeAndLayout() {
    // A largura será 15% da largura da tela
    final screenWidth =
        gameRef.size.x > 0
            ? gameRef.size.x
            : 1280.0; // Fallback para evitar divisão por zero
    final cardWidth = screenWidth * 0.15;
    // Proporção 2:3 (largura:altura)
    final cardHeight = cardWidth * 1.5;
    size = Vector2(cardWidth, cardHeight);

    // Ajustar os retângulos filhos
    cardRect.size = size;
    for (var child in cardRect.children) {
      if (child is RectangleComponent) {
        child.size = size;
      }
    }
  }

  @override
  Future<void> onLoad() async {
    _setSizeAndLayout();
    await add(cardRect);

    nameText = TextComponent(
      text: card.nome.toUpperCase(),
      position: Vector2(size.x / 2, size.y / 3),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
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
    await add(nameText);

    damageText = TextComponent(
      text: 'DANO: ${card.damage}',
      position: Vector2(size.x / 2, size.y * 0.78),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFF4500),
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
    await add(damageText);

    _originalPosition = position.clone();
    originalAngle = angle;
    originalScale = scale.clone();
    print(
      'CardComponent loaded: ${card.nome} at position $position with size $size (card_component.dart)',
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _setSizeAndLayout();
    // Ajustar posições dos textos
    nameText.position = Vector2(this.size.x / 2, this.size.y / 3);
    damageText.position = Vector2(this.size.x / 2, this.size.y * 0.78);
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
