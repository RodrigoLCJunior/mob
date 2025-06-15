/// Este arquivo define a classe `CardComponent`, responsável por renderizar
/// uma carta do jogador (avatar) no jogo de combate baseado em turnos usando o Flame.
///
/// Principais responsabilidades:
/// - Renderiza a frente da carta com base no modelo `Cards`, exibindo apenas a imagem.
/// - Suporta interação de arrastar (quando `isDraggable` é verdadeiro) para a imagem inteira.
/// - Define um tamanho grande para as cartas, inspirado no jogo Night of the Full Moon,
///   com largura de 15% da tela e proporção 2:3 (largura:altura), agora 2/3 maior.
/// - Ajusta os elementos visuais para o novo tamanho.
/// - Aumenta o tamanho da carta para o dobro quando arrastada.

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:midnight_never_end/domain/entities/cards/cards_entity.dart';

class CardComponent extends PositionComponent with DragCallbacks, HasGameRef {
  final Cards card;
  final Function(CardComponent)? onDragEndCallback;
  SpriteComponent? imageComponent; // Remover 'late' e tornar opcional
  bool _isDragging = false;
  Vector2? _originalPosition;
  bool isDraggable;

  late double originalAngle;
  late Vector2 originalScale;

  CardComponent(this.card, {this.onDragEndCallback, this.isDraggable = true})
    : super();

  Vector2 get originalPosition => _originalPosition ?? position;

  void setOriginalPosition(Vector2 newPosition) {
    _originalPosition = newPosition.clone();
  }

  void _setSizeAndLayout() {
    // A largura será 15% da largura da tela, aumentada em 2/3 (1.6667x)
    final screenWidth =
        gameRef.size.x > 0
            ? gameRef.size.x
            : 1280.0; // Fallback para evitar divisão por zero
    final cardWidth =
        screenWidth * 0.15 * 1.6667; // Aumenta 2/3 do tamanho original
    // Proporção 2:3 (largura:altura)
    final cardHeight = cardWidth * 1.5;
    size = Vector2(cardWidth, cardHeight);

    // Ajustar a imagem apenas se já estiver carregada
    if (imageComponent != null) {
      imageComponent!.size = size;
      imageComponent!.position = Vector2.zero();
    }
  }

  @override
  Future<void> onLoad() async {
    _setSizeAndLayout();

    // Carregar a imagem do cartão, usando uma imagem padrão se imageCard for null
    final imagePath = card.imageCard ?? 'assets/images/default_card.png';
    imageComponent = SpriteComponent.fromImage(
      await gameRef.images.load(imagePath),
      size: size,
      anchor: Anchor.topLeft,
    );
    await add(imageComponent!);

    _originalPosition = position.clone();
    originalAngle = angle;
    originalScale = scale.clone();
    priority = 1; // Aumentar prioridade para 1
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _setSizeAndLayout();
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    // Garantir que toda a área da carta seja arrastável
    return point.x >= 0 &&
        point.x <= size.x &&
        point.y >= 0 &&
        point.y <= size.y;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (!isDraggable) return;

    _isDragging = true;
    event.handled = true;
    priority = 100;
    scale = Vector2.all(1.5); // Aumentar para o dobro do tamanho
    angle = 0;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_isDragging) {
      position += event.localDelta;
      angle = 0;
      event.handled = true;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_isDragging) {
      _isDragging = false;
      scale = originalScale.clone(); // Restaurar escala original
      angle = originalAngle;
      priority = 1; // Restaurar prioridade para 1
      if (onDragEndCallback != null) {
        onDragEndCallback!(this);
      }
      event.handled = true;
    }
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _isDragging = false;
    scale = originalScale.clone(); // Restaurar escala original
    angle = originalAngle;
    priority = 1; // Restaurar prioridade para 1
    position = _originalPosition!.clone();
    event.handled = true;
  }
}
