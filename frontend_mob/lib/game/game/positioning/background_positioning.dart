/*
 * Classe: BackgroundPositioning
 * --------------------------------------------------------
 * Esta classe é responsável por gerenciar o fundo visual do jogo de forma isolada,
 * utilizando a biblioteca Flame. Ela encapsula toda a lógica de carregamento,
 * redimensionamento e movimentação do fundo, promovendo modularidade e facilitando
 * a manutenção ou reutilização em diferentes partes do jogo.
 *
 * Funcionalidades principais:
 * 
 * - Carregamento:
 *   - O método `loadBackground` carrega uma imagem de fundo (ex.: 'combat_background.png')
 *     como um `SpriteComponent`, configurando seu tamanho original e prioridade baixa (-1)
 *     para garantir que fique atrás de outros componentes no jogo.
 *
 * - Redimensionamento:
 *   - O método `resizeBackground` ajusta o tamanho do fundo proporcionalmente ao tamanho
 *     da tela, calculando a escala com base na largura ou altura (qualquer que seja o maior)
 *     e centralizando-o para evitar distorções ou bordas indesejadas.
 *
 * - Movimentação:
 *   - O método `moveHorizontally` permite deslocar o fundo horizontalmente por uma quantidade
 *     de pixels especificada (`deltaX`), com limites para evitar que ele saia da tela
 *     (mínimo: 0, máximo: largura da tela menos a largura do fundo).
 *
 * - Acesso ao Tamanho:
 *   - O getter `size` fornece o tamanho atual do fundo, útil para cálculos de posicionamento
 *     ou limites de movimento.
 *
 * A classe utiliza um `SpriteComponent` interno (`_background`) para armazenar o fundo,
 * e todos os métodos são projetados para trabalhar de forma independente do contexto
 * principal do jogo, sendo integrada por meio de uma instância em classes como `CombatGame`.
 */
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class BackgroundPositioning {
  SpriteComponent? _background;

  Future<void> loadBackground(FlameGame game, String assetPath) async {
    final backgroundSprite = await Sprite.load(assetPath);
    _background =
        SpriteComponent()
          ..sprite = backgroundSprite
          ..size = backgroundSprite.originalSize
          ..position = Vector2.zero()
          ..priority = -1;
    game.add(_background!);
  }

  void resizeBackground(Vector2 newSize) {
    if (_background == null) return;

    final backgroundSprite = _background!.sprite!;
    final originalWidth = backgroundSprite.originalSize.x;
    final originalHeight = backgroundSprite.originalSize.y;
    final screenWidth = newSize.x;
    final screenHeight = newSize.y;

    final scaleWidth = screenWidth / originalWidth;
    final scaleHeight = screenHeight / originalHeight;
    final scale = (scaleWidth > scaleHeight ? scaleWidth : scaleHeight);
    _background!.size = Vector2(originalWidth * scale, originalHeight * scale);

    _background!.position = Vector2(
      (screenWidth - _background!.size.x) / 2 +
          20, // Posição Horizontal da Imagem de Fundo
      (screenHeight - _background!.size.y) / 2,
    );
  }

  void moveHorizontally(double deltaX) {
    if (_background == null) return;

    final currentPosition = _background!.position;
    final newX = currentPosition.x + deltaX;

    final maxX = 0.0;
    final minX = size.x - _background!.size.x;
    _background!.position = Vector2(newX.clamp(maxX, minX), currentPosition.y);
  }

  Vector2 get size => _background?.size ?? Vector2.zero();
}
