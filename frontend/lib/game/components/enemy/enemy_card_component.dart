import 'package:flame/components.dart';
import 'package:midnight_never_end/domain/entities/cards/cards_entity.dart';

class EnemyCardComponent extends PositionComponent {
  final Cards card;
  final SpriteComponent cardBack; // Alterado para SpriteComponent
  Vector2? _originalPosition;
  late double originalAngle;
  late Vector2 originalScale;

  EnemyCardComponent(this.card, {Vector2? initialPosition})
    : cardBack = SpriteComponent(size: Vector2(60, 90)),
      super(
        size: Vector2(30, 45),
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
    // Carregar a imagem back_card.png
    final sprite = await Sprite.load('back_card.png');
    cardBack.sprite = sprite;
    cardBack.size =
        size; // Garantir que o tamanho do SpriteComponent seja o mesmo

    // Adicionar o verso da carta (imagem)
    await add(cardBack);

    originalAngle = angle;
    originalScale = scale.clone();
    print(
      'EnemyCardComponent loaded: ${card.nome} at position $position (enemy_card_component.dart)',
    );
  }
}
