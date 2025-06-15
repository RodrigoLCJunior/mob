import 'package:flame/components.dart';
import 'package:midnight_never_end/domain/entities/inimigo/inimigo_entity.dart';

// ignore: deprecated_member_use
class EnemyImageComponent extends SpriteComponent with HasGameRef {
  final Inimigo inimigo;

  EnemyImageComponent(this.inimigo)
    : super(
        size: Vector2(180, 250), // Tamanho Largura e Altura da imagem
        position: Vector2.zero(),
        anchor: Anchor.center,
      );

  @override
  Future<void> onLoad() async {
    final imagePath = inimigo.imageInimigo ?? 'assets/images/ahab.png';
    sprite = await Sprite.load(imagePath, images: gameRef.images);
    //debugMode = true;
  }
}
