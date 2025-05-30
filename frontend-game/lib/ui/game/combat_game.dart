/*
 * Classe: CombatGame
 * --------------------------------------------------------
 * Essa classe representa a tela de combate principal do jogo, utilizando a
 * biblioteca Flame para renderização em tempo real. Ela controla os componentes
 * visuais e a interação entre o jogador e o inimigo, coordenando os elementos
 * do combate como cartas, avatar e inimigo, além de atualizar e animar ações
 * conforme o estado do jogo muda.
 *
 * Funcionalidades principais:
 * 
 * - Inicialização:
 *   - Carrega os dados de combate (inimigo, avatar) e espera a inicialização do CombatBloc.
 *   - Obtém as mãos (maoAvatar e maoInimigo) diretamente do estado do CombatBloc.
 *   - Instancia e posiciona os componentes gráficos: `InimigoComponent`, `AvatarComponent`,
 *     cartas do jogador e do inimigo.
 *   - Marca quando todos os componentes estão prontos para uso (`_isComponentsLoaded`).
 *   - Define se o jogador pode arrastar cartas dependendo de quem inicia o turno.
 *   - Escuta alterações no estado (`viewModel`) e sincroniza a interface automaticamente.
 *
 * - Atualização (update):
 *   - Executada a cada frame; delega a lógica de turno do inimigo para `EnemyAction`.
 *
 * - Responsividade:
 *   - Reposiciona componentes visuais quando a tela muda de tamanho (`onGameResize`),
 *     mantendo tudo centralizado e proporcional.
 *
 * - Fim do Jogo:
 *   - Detecta quando o combate termina (inimigo ou jogador com 0 de vida) e navega para a tela de vitória ou derrota.
 *
 * A classe encapsula tanto a parte visual quanto a lógica de fluxo de turnos no combate,
 * funcionando como o "coração" da fase de batalha.
 */
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:midnight_never_end/models/combat_initial_data.dart';
import 'package:midnight_never_end/models/usuario.dart';
import 'package:midnight_never_end/bloc/combat/combat_view_model.dart';
import 'package:midnight_never_end/ui/components/avatar/avatar_component.dart';
import 'package:midnight_never_end/ui/components/avatar/card_component.dart';
import 'package:midnight_never_end/ui/components/enemy/enemy_card_component.dart';
import 'package:midnight_never_end/ui/components/enemy/enemy_container_component.dart';
import 'package:midnight_never_end/ui/components/enemy/enemy_front_card_component.dart';
import 'package:midnight_never_end/ui/components/info_text_component.dart';
import 'package:midnight_never_end/ui/game/management/enemy_card_management.dart';
import 'package:midnight_never_end/ui/game/management/player_card_management.dart';
import 'package:midnight_never_end/ui/game/positioning/background_positioning.dart';
import 'package:midnight_never_end/ui/game/positioning/enemy_card_positioning.dart';
import 'package:midnight_never_end/ui/game/positioning/player_card_positioning.dart';
import 'package:midnight_never_end/ui/game/enemy_action.dart';
import 'package:midnight_never_end/ui/screens/defeat_screen.dart';
import 'package:midnight_never_end/ui/screens/victory_screen.dart';
import 'state_management.dart';

class CombatGame extends FlameGame {
  final CombatInitialData combatData;
  final Usuario usuario;
  final VoidCallback? onAnimationComplete;
  final CombatViewModel viewModel;
  final BuildContext context;
  EnemyContainerComponent? enemyContainer;
  AvatarComponent? avatarComponent;
  List<CardComponent> cartasJogador = [];
  List<EnemyCardComponent> cartasInimigo = [];
  List<EnemyFrontCardComponent> cartasInimigoFront = [];
  bool _isAnimationComplete = false;
  bool _isComponentsLoaded = false;
  late EnemyAction _enemyAction;
  late BackgroundPositioning _backgroundPositioning;
  int _lastHandledMessageId = -1;

  // Variáveis para controle do turno do inimigo
  bool _isEnemyPlaying = false;
  double _enemyTurnDelay = 0.0;
  bool _hasNavigated = false;

  CombatGame({
    required this.combatData,
    required this.usuario,
    required this.viewModel,
    required this.context,
    this.onAnimationComplete,
  }) {
    _enemyAction = EnemyAction(
      game: this,
      viewModel: viewModel,
      onEnemyTurnComplete: () {
        _isEnemyPlaying = false;
      },
    );
    _backgroundPositioning = BackgroundPositioning();
  }

  bool get isAnimationComplete => _isAnimationComplete;

  bool get isComponentsLoaded => _isComponentsLoaded;

  @override
  Color backgroundColor() => Colors.transparent;

  void _positionEnemy() {
    if (enemyContainer == null || size.x <= 0 || size.y <= 0) {
      print('CombatGame - Warning: Cannot position enemy, invalid state');
      return;
    }
    enemyContainer!.position = Vector2(
      (size.x - enemyContainer!.size.x) / 2,
      size.y * 0.3,
    );
  }

  void _positionAvatar() {
    if (avatarComponent == null || size.x <= 0 || size.y <= 0) {
      print('CombatGame - Warning: Cannot position avatar, invalid state');
      return;
    }
    avatarComponent!.position = Vector2(
      (size.x - avatarComponent!.size.x) / 2,
      size.y * 0.875,
    );
  }

  Future<void> _loadEnemy() async {
    enemyContainer = EnemyContainerComponent(
      combatData.enemy,
      currentHp: combatData.enemy.hp,
    );
    _positionEnemy();
    add(enemyContainer!);
  }

  Future<void> _loadAvatar() async {
    avatarComponent = AvatarComponent(
      usuario,
      combatData.avatar,
      currentHp: combatData.avatar.hp,
    )..size = Vector2(120, 50);
    _positionAvatar();
    add(avatarComponent!);
  }

  void _navigateToResultScreen(String gameResult) {
    if (_hasNavigated) return;

    _hasNavigated = true;
    print('CombatGame - Navigating to result screen: $gameResult');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (gameResult == 'victory') {
        Navigator.of(context)
            .pushReplacement(
              MaterialPageRoute(builder: (context) => const VictoryScreen()),
            )
            .then((_) {
              print('CombatGame - Returned from VictoryScreen');
              _hasNavigated = false;
            })
            .catchError((error) {
              print('CombatGame - Navigation error to VictoryScreen: $error');
              _hasNavigated = false;
            });
      } else if (gameResult == 'defeat') {
        Navigator.of(context)
            .pushReplacement(
              MaterialPageRoute(builder: (context) => const DefeatScreen()),
            )
            .then((_) {
              print('CombatGame - Returned from DefeatScreen');
              _hasNavigated = false;
            })
            .catchError((error) {
              print('CombatGame - Navigation error to DefeatScreen: $error');
              _hasNavigated = false;
            });
      }
    });
  }

  void _checkGameResult() {
    final gameResult = viewModel.state.gameResult;
    if (gameResult != null) {
      _navigateToResultScreen(gameResult);
    }
  }

  @override
  Future<void> onLoad() async {
    await _backgroundPositioning.loadBackground(this, 'combat_background.png');

    await super.onLoad();
    print('CombatGame - onLoad called, game size: $size');

    while (viewModel.state.isLoading || viewModel.state.maoAvatar.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    print(
      'CombatGame - CombatBloc state initialized: '
      'avatar hand=${viewModel.state.maoAvatar.length} cards, '
      'enemy hand=${viewModel.state.maoInimigo.length} cards',
    );

    await _loadEnemy();
    await _loadAvatar();
    await loadPlayerCards(this);
    await loadEnemyCards(this);

    for (var enemyCard in viewModel.state.maoInimigo) {
      final frontCard = EnemyFrontCardComponent(enemyCard);
      await frontCard.onLoad();
      cartasInimigoFront.add(frontCard);
    }

    _isComponentsLoaded = true;

    if (size.x > 0 && size.y > 0) {
      posicionarCartasJogador(this);
      posicionarCartasInimigo(this);
      _isAnimationComplete = true;
      final isPlayerTurn = viewModel.state.isPlayerTurn;
      for (var c in cartasJogador) {
        c.isDraggable = isPlayerTurn;
      }
      onAnimationComplete?.call();
    }

    viewModel.addListener(() => onStateChanged(this));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isComponentsLoaded &&
        !_isEnemyPlaying &&
        !viewModel.state.isPlayerTurn) {
      _enemyTurnDelay += dt;
      if (_enemyTurnDelay >= 1.0) {
        _isEnemyPlaying = true;
        _enemyAction.playEnemyCard();
        _enemyTurnDelay = 0.0;
      }
    }

    if (!_hasNavigated) {
      _checkGameResult();
    }

    if (isComponentsLoaded) {
      final message = viewModel.state.statusMessage;
      final messageId = viewModel.state.statusMessageId;

      if (message != null && messageId != _lastHandledMessageId) {
        final position = Vector2(size.x / 2, size.y * 0.5);
        final infoText = InfoTextComponent(message, position);
        add(infoText);

        _lastHandledMessageId = messageId;
        viewModel.clearStatusMessage(); // dispara evento
      }
    }
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    print('CombatGame - Game resized to: $newSize');

    if (!_isComponentsLoaded) return;

    _backgroundPositioning.resizeBackground(newSize);

    if (enemyContainer != null) {
      _positionEnemy();
    }
    if (avatarComponent != null) {
      _positionAvatar();
    }

    posicionarCartasJogador(this);
    posicionarCartasInimigo(this);
  }

  void moveBackgroundHorizontally(double deltaX) {
    _backgroundPositioning.moveHorizontally(deltaX);
  }
}
