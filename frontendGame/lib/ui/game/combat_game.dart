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
import 'package:midnight_never_end/ui/components/enemy/enemy_component.dart';
import 'package:midnight_never_end/ui/game/management/enemy_card_management.dart';
import 'package:midnight_never_end/ui/game/management/player_card_management.dart';
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
  InimigoComponent? inimigoComponent;
  AvatarComponent? avatarComponent;
  List<CardComponent> cartasJogador = [];
  List<EnemyCardComponent> cartasInimigo = [];
  bool _isAnimationComplete = false;
  bool _isComponentsLoaded = false;
  late EnemyAction _enemyAction;

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
  }

  bool get isAnimationComplete => _isAnimationComplete;

  bool get isComponentsLoaded => _isComponentsLoaded;

  @override
  Color backgroundColor() => const Color(0xFF1A1A1A);

  void _positionEnemy() {
    if (inimigoComponent == null || size.x <= 0 || size.y <= 0) {
      print('CombatGame - Warning: Cannot position enemy, invalid state');
      return;
    }
    inimigoComponent!.position = Vector2(
      (size.x - inimigoComponent!.size.x) / 2,
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
    inimigoComponent = InimigoComponent(
      combatData.enemy,
      currentHp: combatData.enemy.hp,
    );
    _positionEnemy();
    add(inimigoComponent!);
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

  void _checkGameResult() {
    if (_hasNavigated) return;

    final gameResult = viewModel.state.gameResult;
    if (gameResult != null) {
      _hasNavigated = true;
      if (gameResult == 'victory') {
        print('CombatGame - Player victory! Navigating to VictoryScreen');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const VictoryScreen()),
        );
      } else if (gameResult == 'defeat') {
        print('CombatGame - Player defeated! Navigating to DefeatScreen');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DefeatScreen()),
        );
      }
    }
  }

  @override
  Future<void> onLoad() async {
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

    _checkGameResult();
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    print('CombatGame - Game resized to: $newSize');

    if (!_isComponentsLoaded) return;

    if (inimigoComponent != null) {
      _positionEnemy();
    }
    if (avatarComponent != null) {
      _positionAvatar();
    }

    posicionarCartasJogador(this);
    posicionarCartasInimigo(this);
  }
}
