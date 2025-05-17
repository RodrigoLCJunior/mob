/// Este arquivo define a classe `EnemyAnimatedCard`, usada para animar visualmente
/// uma carta jogada pelo inimigo contra o avatar do jogador no jogo de combate.
///
/// Principais responsabilidades:
///
/// - Extende `BaseAnimatedCard` para herdar a lógica de animação comum.
/// - Adiciona um `CardComponent` como filho para renderizar a frente da carta,
///   permitindo que o jogador veja os detalhes da carta durante o ataque.
/// - Quando a animação termina, executa `viewModel.playEnemyCard` ou o callback fornecido.
///
/// Essa classe é usada para criar um efeito visual dinâmico e responsivo ao ataque do inimigo,
/// exibindo a frente da carta para que o jogador entenda a ação realizada.

/*import 'package:flame/components.dart';
import 'package:flutter/animation.dart';
import 'package:midnight_never_end/models/card.dart';
import 'package:midnight_never_end/bloc/combat/combat_view_model.dart';
import 'package:midnight_never_end/ui/components/enemy/enemy_front_card_component.dart';
import 'base_animated_card.dart';

class EnemyAnimatedCard extends BaseAnimatedCard {
  final CombatViewModel viewModel;
  late EnemyFrontCardComponent cardComponent;

  EnemyAnimatedCard({
    required Cards card,
    required Vector2 startPosition,
    required double startAngle,
    required Vector2 targetPosition,
    required int cardIndex,
    required this.viewModel,
    VoidCallback? onAnimationComplete,
  }) : super(
         card: card,
         startPosition: startPosition,
         startAngle: startAngle,
         targetPosition: targetPosition,
         cardIndex: cardIndex,
         onAnimationComplete: onAnimationComplete,
       ) {
    cardComponent = EnemyFrontCardComponent(card);
    add(cardComponent);
  }

  @override
  void onComplete() {
    if (onAnimationComplete != null) {
      onAnimationComplete!();
    } else {
      viewModel.playEnemyCard(card, cardIndex);
    }
  }
}*/

/// Este arquivo define a classe `EnemyAnimatedCard`, usada para animar visualmente
/// uma carta jogada pelo inimigo no jogo de combate.
///
/// Principais responsabilidades:
///
/// - Renderiza a frente da carta usando `EnemyFrontCardComponent`.
/// - Anima a carta para o centro da tela, aumenta o tamanho (zoom), pausa, faz um fadeout e a remove.
/// - Ao final da animação, executa `viewModel.playEnemyCard` ou o callback fornecido.
///
/// Essa classe cria um efeito visual dinâmico para exibir a carta ao jogador.
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:midnight_never_end/models/card.dart';
import 'package:midnight_never_end/bloc/combat/combat_view_model.dart';
import 'package:midnight_never_end/ui/components/enemy/enemy_front_card_component.dart';

class EnemyAnimatedCard extends PositionComponent with HasGameRef {
  final Cards card;
  final Vector2 startPosition;
  final double startAngle;
  final Vector2 targetPosition;
  final int cardIndex;
  final CombatViewModel viewModel;
  final VoidCallback? onAnimationComplete;
  late EnemyFrontCardComponent cardComponent;
  double _scale = 1.0; // Para controlar o zoom
  double _opacity = 1.0; // Para controlar o fadeout
  bool _isAnimating = false;

  EnemyAnimatedCard({
    required this.card,
    required this.startPosition,
    required this.startAngle,
    required this.targetPosition,
    required this.cardIndex,
    required this.viewModel,
    this.onAnimationComplete,
  }) : super(priority: 1000) {
    // Definir alta prioridade para ficar na frente
    position = startPosition;
    angle = startAngle;
    cardComponent = EnemyFrontCardComponent(card)
      ..position = Vector2.zero(); // Posicionar no centro do pai
    add(cardComponent);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Garantir que o tamanho inicial seja aplicado
    cardComponent.size = Vector2(60, 90); // Forçar o tamanho baseado no log
    startAnimation();
  }

  void startAnimation() {
    if (_isAnimating) return;
    _isAnimating = true;

    // Etapa 1: Mover para o centro da tela e corrigir a rotação
    final centerPosition = Vector2(
      (gameRef.size.x / 2 - cardComponent.size.x / 2) +
          30, // Posição da Carta Quando Mostra ela
      gameRef.size.y / 2 - cardComponent.size.y / 2,
    );
    final moveDuration = 0.3; // Reduzido para 0.3 segundos

    add(
      MoveToEffect(
        centerPosition,
        EffectController(duration: moveDuration),
        onComplete: () {
          add(
            RotateEffect.to(
              0.0,
              EffectController(duration: moveDuration),
              onComplete: () {
                // Etapa 2: Aumentar o tamanho (zoom)
                add(
                  ScaleEffect.to(
                    Vector2.all(2.5),
                    EffectController(
                      duration: 0.3,
                    ), // Reduzido para 0.3 segundos
                    onComplete: () {
                      _scale = 2.0;
                      // Etapa 3: Pausa para mostrar a carta
                      add(
                        TimerComponent(
                          period: 0.5, // Reduzido para 0.5 segundos
                          removeOnFinish: true,
                          onTick: () {
                            // Etapa 4: Fadeout
                            _opacity = 1.0;
                            int fadeTicks = 0;
                            add(
                              TimerComponent(
                                period:
                                    0.03, // 0.03 segundos por tick (0.3s total para 10 ticks)
                                repeat: true, // Agora usa um bool
                                onTick: () {
                                  fadeTicks++;
                                  _opacity -=
                                      0.1; // Reduzir opacidade gradualmente
                                  cardComponent
                                      .imageComponent
                                      .opacity = _opacity.clamp(0.0, 1.0);
                                  if (fadeTicks >= 10) {
                                    // Parar após 10 ticks (0.3s)
                                    _opacity = 0.0;
                                    cardComponent.imageComponent.opacity = 0.0;
                                    // Etapa 5: Finalizar a animação
                                    onComplete();
                                    removeFromParent();
                                    // Remover este timer
                                    children
                                        .whereType<TimerComponent>()
                                        .forEach((timer) {
                                          timer.removeFromParent();
                                        });
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void onComplete() {
    if (onAnimationComplete != null) {
      onAnimationComplete!();
    } else {
      viewModel.playEnemyCard(card, cardIndex);
    }
  }
}
