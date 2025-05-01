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
 *   - Executada a cada frame; verifica se é o turno do inimigo e inicia sua jogada após
 *     um pequeno atraso para dar tempo ao jogador de perceber a mudança.
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
import 'package:midnight_never_end/ui/components/avatar_component.dart';
import 'package:midnight_never_end/ui/components/card_component.dart';
import 'package:midnight_never_end/ui/components/enemy_component.dart';
import 'package:midnight_never_end/bloc/combat/combat_view_model.dart';
import 'package:midnight_never_end/ui/screens/defeat_screen.dart';
import 'package:midnight_never_end/ui/screens/victory_screen.dart';
import 'card_management.dart';
import 'card_positioning.dart';
import 'state_management.dart';
import 'enemy_action.dart';

class CombatGame extends FlameGame {
  final CombatInitialData combatData;
  final Usuario usuario;
  final VoidCallback? onAnimationComplete;
  final CombatViewModel viewModel;
  final BuildContext context; // Adicionado para navegação
  InimigoComponent? inimigoComponent;
  AvatarComponent? avatarComponent;
  List<CardComponent> cartasJogador = [];
  List<CardComponent> cartasInimigo = [];
  late EnemyAction enemyAction;
  bool _isAnimationComplete = false;
  bool _isComponentsLoaded = false;
  bool _isEnemyPlaying = false;
  double _enemyTurnDelay = 0.0;
  bool _hasNavigated = false; // Evita múltiplas navegações

  CombatGame({
    required this.combatData,
    required this.usuario,
    required this.viewModel,
    required this.context, // Adicionado
    this.onAnimationComplete,
  });

  bool get isAnimationComplete => _isAnimationComplete;

  bool get isComponentsLoaded => _isComponentsLoaded;

  @override
  Color backgroundColor() => const Color(0xFF1A1A1A);

  // --- Funções Auxiliares ---

  /// Posiciona um componente no centro horizontal e em uma posição Y relativa.
  void _positionComponent(PositionComponent component, double yPercent) {
    if (size.x > 0 && size.y > 0) {
      component.position = Vector2(
        (size.x - component.size.x) / 2,
        size.y * yPercent,
      );
    }
  }

  /// Carrega e adiciona os componentes do inimigo e do avatar.
  Future<void> _loadCharacters() async {
    // Inimigo (parte superior)
    inimigoComponent = InimigoComponent(
      combatData.enemy,
      currentHp: combatData.enemy.hp,
    )..size = Vector2(120, 64);
    _positionComponent(inimigoComponent!, 0.3); // 30% da altura
    add(inimigoComponent!);

    // Avatar (parte inferior)
    avatarComponent = AvatarComponent(
      usuario,
      combatData.avatar,
      currentHp: combatData.avatar.hp,
    )..size = Vector2(120, 50);
    _positionComponent(avatarComponent!, 0.875); // 87.5% da altura
    add(avatarComponent!);
  }

  /// Carrega as cartas do inimigo a partir do estado do CombatBloc.
  Future<void> _loadEnemyCards() async {
    for (int i = 0; i < viewModel.state.maoInimigo.length; i++) {
      final carta = CardComponent(
        viewModel.state.maoInimigo[i],
        isDraggable: false,
      );
      cartasInimigo.add(carta);
      add(carta);
    }
  }

  /// Verifica o resultado do jogo e navega para a tela apropriada.
  void _checkGameResult() {
    if (_hasNavigated) return; // Evita múltiplas navegações

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

  // --- Métodos do Ciclo de Vida ---

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print('CombatGame - onLoad called, game size: $size');

    // Aguardar até que o CombatBloc tenha inicializado o estado
    while (viewModel.state.isLoading || viewModel.state.maoAvatar.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    print(
      'CombatGame - CombatBloc state initialized: '
      'avatar hand=${viewModel.state.maoAvatar.length} cards, '
      'enemy hand=${viewModel.state.maoInimigo.length} cards',
    );

    // Carregar os personagens
    await _loadCharacters();

    // Carregar as cartas do jogador
    await loadPlayerCards(this);

    // Carregar as cartas do inimigo
    await _loadEnemyCards();

    // Inicializar a lógica de ações do inimigo
    enemyAction = EnemyAction(
      game: this,
      viewModel: viewModel,
      onEnemyTurnComplete: () {
        _isEnemyPlaying = false;
      },
    );

    // Marcar os componentes como carregados
    _isComponentsLoaded = true;

    // Posicionar as cartas e finalizar a inicialização
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

    // Ouvir mudanças no estado via ViewModel
    viewModel.addListener(() => onStateChanged(this));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Verificar se é o turno do inimigo
    if (isComponentsLoaded &&
        !_isEnemyPlaying &&
        !viewModel.state.isPlayerTurn) {
      _enemyTurnDelay += dt;
      if (_enemyTurnDelay >= 1.0) {
        _isEnemyPlaying = true;
        enemyAction.playEnemyCard();
        _enemyTurnDelay = 0.0;
      }
    }

    // Verificar o resultado do jogo a cada atualização
    _checkGameResult();
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    print('CombatGame - Game resized to: $newSize');

    if (!_isComponentsLoaded) return;

    // Reposicionar os personagens
    if (inimigoComponent != null) {
      _positionComponent(inimigoComponent!, 0.3);
    }
    if (avatarComponent != null) {
      _positionComponent(avatarComponent!, 0.875);
    }

    // Reposicionar as cartas
    posicionarCartasJogador(this);
    posicionarCartasInimigo(this);
  }
}
