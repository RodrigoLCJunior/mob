/*import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:midnight_never_end/models/inimigo.dart';
import 'package:midnight_never_end/ui/components/damage_text_component.dart';
import 'package:midnight_never_end/ui/components/enemy/enemy_heathbar_component.dart';

class InimigoComponent extends PositionComponent {
  final Inimigo inimigo;
  final RectangleComponent inimigoRect;
  late EnemyHealthBarComponent healthBar;
  late TextComponent nameText;
  int currentHp;

  InimigoComponent(this.inimigo, {required this.currentHp})
    : inimigoRect = RectangleComponent(
        size: Vector2(120, 50),
        paint:
            Paint()
              ..color = const Color(0xFF8B0000)
              ..style = PaintingStyle.fill,
        children: [
          RectangleComponent(
            size: Vector2(120, 50),
            paint:
                Paint()
                  ..color = const Color(0xFFDAA520)
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3,
          ),
          RectangleComponent(
            size: Vector2(120, 50),
            position: Vector2(3, 3),
            paint:
                Paint()
                  ..color = const Color(0x80000000)
                  ..style = PaintingStyle.fill,
            priority: -1,
          ),
        ],
      ),
      super(size: Vector2(120, 64));

  @override
  Future<void> onLoad() async {
    print('InimigoComponent - onLoad called (enemy_component.dart)');

    // Adicionar retângulo centralizado
    inimigoRect.position = Vector2(
      (size.x - 120) / 2,
      0,
    ); // Centralizar horizontalmente
    await add(inimigoRect);

    // Nome do inimigo
    nameText = TextComponent(
      text: inimigo.nome.toUpperCase(),
      position: Vector2(size.x / 2, 25),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
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
    await add(nameText);

    // Barra de vida centralizada, com largura e posição como no original
    healthBar = EnemyHealthBarComponent(
      maxHp: inimigo.hp,
      currentHp: currentHp,
      size: Vector2(100, 14), // Largura fixa como no original
      position: Vector2(10, 50), // Mesma posição do original
    );
    await add(healthBar);
  }

  // Método para obter a posição central absoluta do inimigo (usado pela animação da carta)
  Vector2 getCenterPosition() {
    // Calcular o centro local do inimigoRect em relação ao InimigoComponent
    final localCenter =
        inimigoRect.position +
        Vector2(inimigoRect.size.x / 2, inimigoRect.size.y / 2);
    // Converter para posição global (método manual, já que toGlobal() não está disponível)
    final globalPosition = position + localCenter;
    var current = parent;
    var finalPosition = globalPosition;
    while (current != null && current is PositionComponent) {
      finalPosition += (current).position;
      current = current.parent;
    }
    return finalPosition;
  }

  // Método para obter a posição do texto de dano (acima da barra de vida)
  Vector2 getDamageTextPosition() {
    // A healthBar está em position: Vector2((size.x - 100) / 2, 50), com size: Vector2(100, 14)
    final healthBarCenterX = healthBar.position.x + healthBar.size.x / 2;
    final healthBarTopY =
        healthBar.position.y - 2; // 2 pixels acima do topo da barra de vida
    return Vector2(healthBarCenterX, healthBarTopY);
  }

  void takeDamage(int damage) {
    final newHp = (currentHp - damage).clamp(0, inimigo.hp);
    currentHp = newHp;
    healthBar.updateHp(currentHp);

    // Adicionar texto flutuante de dano, posicionado acima da barra de vida
    final damageTextPos = getDamageTextPosition();
    final damageText = DamageText(
      '-$damage',
      damageTextPos, // Posição local acima da barra de vida
    );
    add(damageText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // A animação da barra de vida é gerenciada pelo EnemyHealthBarComponent
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    size = Vector2(
      gameSize.x * 0.8,
      64,
    ); // 80% da largura da tela, altura como no original
    inimigoRect.size = Vector2(120, 50);
    inimigoRect.position = Vector2(
      (size.x - 120) / 2,
      0,
    ); // Centralizar horizontalmente
    nameText.position = Vector2(size.x / 2, 25);
    healthBar.size = Vector2(100, 14); // Manter largura fixa
    healthBar.position = Vector2(
      (size.x - 100) / 2,
      50,
    ); // Centralizar horizontalmente, mesma posição y
  }

  void updateInimigo(Inimigo newInimigo, {required int enemyHp}) {
    if (enemyHp < currentHp) {
      final damage = currentHp - enemyHp;
      takeDamage(damage);
    } else {
      currentHp = enemyHp;
      healthBar.updateHp(currentHp);
    }
  }
}*/
