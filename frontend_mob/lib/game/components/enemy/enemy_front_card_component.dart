/// Este arquivo define a classe `EnemyFrontCardComponent`, responsável por renderizar
/// a frente de uma carta do inimigo no jogo de combate baseado em turnos usando o Flame.
///
/// Principais responsabilidades:
/// - Renderiza a frente da carta com base no modelo `Cards`, exibindo a imagem.
/// - Mantém um tamanho fixo de 60x90 para consistência visual.
/// - Não suporta interações de arrastar, focando apenas na exibição.
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:midnight_never_end/domain/entities/cards/cards_entity.dart';

class EnemyFrontCardComponent extends PositionComponent with HasGameRef {
  final Cards card;
  late SpriteComponent imageComponent;

  EnemyFrontCardComponent(this.card) : super(size: Vector2(60, 90));

  @override
  Future<void> onLoad() async {
    //debugMode = true; // Ativar o modo de depuração para facilitar o desenvolvimento
    // Carregar a imagem da carta, usando uma imagem padrão se imageCard for null
    final imagePath = card.imageCard ?? 'assets/images/default_card.png';
    imageComponent = SpriteComponent.fromImage(
      await gameRef.images.load(imagePath),
      size: size,
      anchor: Anchor.center,
    );
    await add(imageComponent);
  }
}
