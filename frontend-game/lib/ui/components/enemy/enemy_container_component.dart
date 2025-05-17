import 'package:flame/components.dart';
import 'package:midnight_never_end/models/inimigo.dart';
import 'package:midnight_never_end/ui/components/damage_text_component.dart';
import 'package:midnight_never_end/ui/components/enemy/enemy_image_component.dart';
import 'package:midnight_never_end/ui/components/enemy/enemy_background_component.dart';
import 'package:midnight_never_end/ui/components/enemy/enemy_name_component.dart';
import 'package:midnight_never_end/ui/components/enemy/enemy_heathbar_component.dart';

class EnemyContainerComponent extends PositionComponent with HasGameRef {
  final Inimigo inimigo;
  late EnemyImageComponent enemyImage;
  late EnemyBackgroundComponent enemyBackground;
  late EnemyNameComponent enemyName;
  late EnemyHealthBarComponent healthBar;
  late SpriteComponent poisonIcon;

  int currentHp;
  bool _isLoaded = false;

  EnemyContainerComponent(this.inimigo, {required this.currentHp})
    : super(
        size: Vector2(180, 170),
      ); // Largura mínima igual ao tamanho da imagem

  @override
  Future<void> onLoad() async {
    print(
      'EnemyContainerComponent - onLoad called (enemy_container_component.dart)',
    );

    // Adicionar imagem
    enemyImage = EnemyImageComponent(inimigo)
      ..position = Vector2(90, 80); // Centralizar no eixo y
    await add(enemyImage);

    // Adicionar retângulo de fundo
    enemyBackground =
        EnemyBackgroundComponent()
          ..position = Vector2(0, 90); // Abaixo da imagem
    await add(enemyBackground);

    // Adicionar nome
    enemyName = EnemyNameComponent(inimigo)
      ..position = Vector2(90, 115); // Dentro do retângulo
    await add(enemyName);

    // Adicionar barra de vida
    healthBar = EnemyHealthBarComponent(
      maxHp: inimigo.hp,
      currentHp: currentHp,
      size: Vector2(100, 14),
    )..position = Vector2(40, 140); // Abaixo do retângulo
    await add(healthBar);

    poisonIcon = SpriteComponent()
      ..sprite = await Sprite.load('../icons/iconeVeneno.png')
      ..size = Vector2(35, 35)
      ..position = Vector2(
        healthBar.position.x + healthBar.size.x + 160,
        healthBar.position.y + (healthBar.size.y - 35) / 2, // centralizar verticalmente
      )
      ..opacity = 0.0;

    await add(poisonIcon);

    _isLoaded = true;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    size = Vector2(gameSize.x, 170); // Usar largura total da tela
    if (_isLoaded) {
      // Centralizar a imagem em relação à largura total da tela
      enemyImage.position = Vector2(gameSize.x / 2, 60);
      // Centralizar os outros elementos em relação à largura total
      enemyBackground.position = Vector2((gameSize.x - 120) / 2, 90);
      enemyName.position = Vector2(gameSize.x / 2, 115);
      healthBar.position = Vector2((gameSize.x - 100) / 2, 140);
      healthBar.size = Vector2(100, 14);
    }
  }

  Vector2 getCenterPosition() {
    final localCenter =
        enemyBackground.position +
        Vector2(enemyBackground.size.x / 2, enemyBackground.size.y / 2);
    final globalPosition = position + localCenter;
    var current = parent;
    var finalPosition = globalPosition;
    while (current != null && current is PositionComponent) {
      finalPosition += (current).position;
      current = current.parent;
    }
    return finalPosition;
  }

  Vector2 getDamageTextPosition() {
    final healthBarCenterX = healthBar.position.x + healthBar.size.x / 2;
    final healthBarTopY = healthBar.position.y - 2;
    return Vector2(healthBarCenterX, healthBarTopY);
  }

  void takeDamage(int damage) {
    final newHp = (currentHp - damage).clamp(0, inimigo.hp);
    currentHp = newHp;
    healthBar.updateHp(currentHp);

    final damageTextPos = getDamageTextPosition();
    final damageText = DamageText('-$damage', damageTextPos);
    add(damageText);
  }

  void updateInimigo(Inimigo newInimigo, {required int enemyHp, required int poisonTurns}) {
    if (enemyHp < currentHp) {
      final damage = currentHp - enemyHp;
      takeDamage(damage);
    } else {
      currentHp = enemyHp;
      healthBar.updateHp(currentHp);
    }

    updatePoisonIcon(poisonTurns: poisonTurns);
  }

  void updatePoisonIcon({required int poisonTurns}) {
    poisonIcon.opacity = poisonTurns > 0 ? 1.0 : 0.0;
  }
}
