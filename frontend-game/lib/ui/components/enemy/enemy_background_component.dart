import 'package:flame/components.dart';
import 'package:midnight_never_end/models/inimigo.dart';

// ignore: deprecated_member_use
class EnemyBackgroundComponent extends SpriteComponent with HasGameRef {
  EnemyBackgroundComponent()
    : super(
        size: Vector2(120, 50),
        position: Vector2.zero(),
        anchor: Anchor.topLeft,
      );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('namePlacer.png', images: gameRef.images);
  }
}
