/// Este arquivo define a classe `CombatBloc`, responsável por gerenciar a lógica de combate
/// em um jogo de cartas baseado em turnos usando o padrão BLoC (Business Logic Component).
///
/// Eventos tratados:
/// - `InitializeCombat`: Inicializa o estado do combate com os dados fornecidos (decks e vida dos personagens).
/// - `PassTurn`: Alterna entre o turno do jogador e do inimigo, e o inimigo adiciona 5 novas cartas à mão.
/// - `PlayCard`: O jogador joga uma carta; reduz a vida do inimigo, retorna a carta ao deck e verifica se o inimigo foi derrotado.
/// - `PlayEnemyCard`: O inimigo joga uma carta; reduz a vida do jogador, retorna a carta ao deck e verifica se o jogador foi derrotado.
/// - `EndEnemyTurn`: Finaliza o turno do inimigo, o jogador adiciona 5 novas cartas à mão, e inicia o turno do jogador.
/// - `StartDungeonCombat`: Inicia um combate dentro de uma dungeon, configurando as waves com base em qtdWaves.
/// - `NextWave`: Avança para a próxima wave da dungeon, escolhendo um novo inimigo aleatório.
/// - `EndDungeon`: Finaliza a dungeon com um resultado (vitória ou derrota).
///
/// Detalhes:
/// - A mão inicial de cada jogador contém 5 cartas aleatórias, selecionadas a partir de uma cópia do respectivo deck.
/// - A cada turno, o jogador (ou inimigo) adiciona 5 novas cartas à sua mão, criando cópias das cartas do deck com novos `id`s únicos.
/// - Um contador global (`_cardIdCounter`) é usado para gerar `id`s únicos para cada carta copiada, incrementando o contador a cada nova carta.
/// - O deck original do jogador e do inimigo permanece inalterado durante o jogo (exceto quando cartas jogadas são adicionadas de volta).
/// - Quando uma carta é jogada, ela é retornada ao deck correspondente.
/// - O BLoC gerencia o `CombatState`, que armazena as mãos, decks, pontos de vida, turnos, resultado do jogo e estado das waves.

import 'package:bloc/bloc.dart';
import 'package:midnight_never_end/models/combat.dart';
import 'package:midnight_never_end/models/card.dart';
import 'package:midnight_never_end/models/inimigo.dart';
import 'package:midnight_never_end/services/api_service.dart';
import 'combat_event.dart';
import 'combat_state.dart';
import 'dart:math' as math;

class DrawResult {
  final List<Cards> hand;
  final String? message;

  DrawResult(this.hand, this.message);
}

class CombatBloc extends Bloc<CombatEvent, CombatState> {
  int _turnGlobalCounter = 1;
  int _cardIdCounter = 0;
  final ApiService apiService;
  List<Inimigo> _allEnemies = []; 
  List<int> _inimigosDerrotados = [];

  CombatBloc({required this.apiService}) : super(CombatState.initial()) {
    on<InitializeCombat>(_onInitializeCombat);
    on<PassTurn>(_onPassTurn);
    on<PlayCard>(_onPlayCard);
    on<PlayEnemyCard>(_onPlayEnemyCard);
    on<EndEnemyTurn>(_onEndEnemyTurn);
    on<StartDungeonCombat>(_onStartDungeonCombat);
    on<NextWave>(_onNextWave);
    on<EndDungeon>(_onEndDungeon);
  }

  // --- Funções Auxiliares ---

  Cards _copyCardWithNewId(Cards card) {
    _cardIdCounter++;
    return Cards(
      id: _cardIdCounter,
      nome: card.nome,
      valor: card.valor,
      imageCard: card.imageCard,
      tipoEfeito: card.tipoEfeito,
      descricao: card.descricao,
      qtdTurnos: card.qtdTurnos,
    );
  }

  DrawResult _drawCards({
    required List<Cards> currentHand,
    required List<Cards> originalDeck,
    required int cardsToDraw,
    bool notifyOverflow = false,
  }) {
    final newHand = List<Cards>.from(currentHand);
    final deckCopy = List<Cards>.from(originalDeck);
    final random = math.Random();

    const maxHandSize = 12;
    String? statusMessage;

    if (newHand.length >= maxHandSize) {
      final indicesToReplace = <int>{};
      while (indicesToReplace.length < 3 && indicesToReplace.length < newHand.length) {
        indicesToReplace.add(random.nextInt(newHand.length));
      }

      for (final index in indicesToReplace) {
        if (deckCopy.isEmpty) break;
        final cardIndex = random.nextInt(deckCopy.length);
        final replacement = _copyCardWithNewId(deckCopy[cardIndex]);
        newHand[index] = replacement;
        deckCopy.removeAt(cardIndex);
      }

      if (notifyOverflow) {
        statusMessage = "Você atingiu o limite de 12 cartas. 3 cartas foram substituídas aleatoriamente.";
        print("CombatBloc - $statusMessage");
      }

      return DrawResult(newHand, statusMessage);
    }

    for (int i = 0; i < cardsToDraw && newHand.length < maxHandSize; i++) {
      if (deckCopy.isEmpty) {
        if (originalDeck.isEmpty) break;
        deckCopy.addAll(originalDeck);
      }
      final index = random.nextInt(deckCopy.length);
      final selectedCard = deckCopy[index];
      newHand.add(_copyCardWithNewId(selectedCard));
      deckCopy.removeAt(index);
    }

    return DrawResult(newHand, null);
  }

  int _updateHp(int currentHp, int damage) {
    final newHp = currentHp - damage;
    return newHp < 0 ? 0 : newHp;
  }

  Inimigo _escolherInimigoAleatorio() {
    final random = math.Random();
    // Filtrar inimigos ainda não derrotados
    List<Inimigo> inimigosDisponiveis = _allEnemies.where((inimigo) => !_inimigosDerrotados.contains(inimigo.id)).toList();

    if (inimigosDisponiveis.isEmpty) {
      // Se todos foram derrotados, resetar a lista de derrotados e usar todos os inimigos novamente
      print('CombatBloc - Todos os inimigos foram derrotados. Reutilizando inimigos...');
      _inimigosDerrotados.clear();
      inimigosDisponiveis = _allEnemies;
    }

    return inimigosDisponiveis[random.nextInt(inimigosDisponiveis.length)];
  }

  // --- Manipuladores de Eventos ---

  Future<void> _onInitializeCombat(
    InitializeCombat event,
    Emitter<CombatState> emit,
  ) async {
    print('CombatBloc - Initializing combat with data: ${event.initialData}');

    _turnGlobalCounter = 1;
    _cardIdCounter = 0;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final combat = Combat.fromInitialData(event.initialData);
      print(
        'CombatBloc - Combat initialized: avatarHp=${combat.avatarHp}, enemyHp=${combat.enemyHp}',
      );

      final List<Cards> deckAvatar = List.from(event.initialData.avatar.deck);
      final result = _drawCards(
        currentHand: [],
        originalDeck: deckAvatar,
        cardsToDraw: 5,
      );

      final List<Cards> maoAvatar = result.hand;
      print('CombatBloc - Avatar hand: ${maoAvatar.length} cards');

      final List<Cards> deckInimigo = List.from(event.initialData.enemy.deck);
      final List<Cards> maoInimigo = [];

      emit(
        state.copyWith(
          isLoading: false,
          combat: combat,
          maoAvatar: maoAvatar,
          maoInimigo: maoInimigo,
          deckAvatar: deckAvatar,
          deckInimigo: deckInimigo,
          error: null,
          currentEnemy: event.initialData.enemy,
        ),
      );
      print(
        'CombatBloc - Initialized state: isPlayerTurn=${state.isPlayerTurn}, '
        'playerTurnCount=${state.playerTurnCount}, enemyTurnCount=${state.enemyTurnCount}, '
        'avatar hand=${state.maoAvatar.length} cards, enemy hand=${state.maoInimigo.length} cards',
      );
    } catch (e) {
      print('CombatBloc - Error initializing combat: $e');
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Erro ao inicializar combate: $e',
        ),
      );
    }
  }

  Future<void> _onPassTurn(PassTurn event, Emitter<CombatState> emit) async {
    int newAvatarHp = state.combat?.avatarHp ?? 0;
    int newEnemyHp = state.combat?.enemyHp ?? 0;

    int venenoAvatarTurnos = state.venenoAvatarTurnos;
    int venenoInimigoTurnos = state.venenoInimigoTurnos;
    int venenoAvatarValor = state.venenoAvatarValor;
    int venenoInimigoValor = state.venenoInimigoValor;

    if (state.isPlayerTurn && venenoInimigoTurnos > 0) {
      newEnemyHp = _updateHp(newEnemyHp, venenoInimigoValor);
      venenoInimigoTurnos--;
      if (venenoInimigoTurnos == 0) venenoInimigoValor = 0;
    } else if (!state.isPlayerTurn && venenoAvatarTurnos > 0) {
      newAvatarHp = _updateHp(newAvatarHp, venenoAvatarValor);
      venenoAvatarTurnos--;
      if (venenoAvatarTurnos == 0) venenoAvatarValor = 0;
    }

    String? gameResult;
    if (newEnemyHp <= 0) {
      if (state.isDungeon) {
        add(NextWave());
        return;
      } else {
        gameResult = 'victory';
      }
    }
    if (newAvatarHp <= 0) {
      if (state.isDungeon) {
        add(EndDungeon(false));
        return;
      } else {
        gameResult = 'defeat';
      }
    }

    print(
      'CombatBloc - Passing turn. Current state: isPlayerTurn=${state.isPlayerTurn}, '
      'playerTurnCount=${state.playerTurnCount}, enemyTurnCount=${state.enemyTurnCount}, '
      'avatar hand=${state.maoAvatar.length} cards, enemy hand=${state.maoInimigo.length} cards',
    );

    _turnGlobalCounter++;
    print('CombatBloc - Turn global counter: $_turnGlobalCounter');

    if (state.isPlayerTurn) {
      final newEnemyTurnCount = state.enemyTurnCount + 1;
      final cardsToDraw = _turnGlobalCounter == 2 ? 5 : 3;

      final result = _drawCards(
        currentHand: state.maoInimigo,
        originalDeck: state.deckInimigo,
        cardsToDraw: cardsToDraw,
        notifyOverflow: true,
      );

      emit(
        state.copyWith(
          isPlayerTurn: false,
          enemyTurnCount: newEnemyTurnCount,
          maoInimigo: result.hand,
          venenoAvatarTurnos: venenoAvatarTurnos,
          venenoAvatarValor: venenoAvatarValor,
          venenoInimigoTurnos: venenoInimigoTurnos,
          venenoInimigoValor: venenoInimigoValor,
          combat: state.combat?.copyWith(
            avatarHp: newAvatarHp,
            enemyHp: newEnemyHp,
          ),
          gameResult: gameResult,
        ),
      );
    } else {
      final newPlayerTurnCount = state.playerTurnCount + 1;
      final result = _drawCards(
        currentHand: state.maoAvatar,
        originalDeck: state.deckAvatar,
        cardsToDraw: 3,
        notifyOverflow: true,
      );

      emit(
        state.copyWith(
          isPlayerTurn: true,
          playerTurnCount: newPlayerTurnCount,
          maoAvatar: result.hand,
          venenoAvatarTurnos: venenoAvatarTurnos,
          venenoAvatarValor: venenoAvatarValor,
          venenoInimigoTurnos: venenoInimigoTurnos,
          venenoInimigoValor: venenoInimigoValor,
          combat: state.combat?.copyWith(
            avatarHp: newAvatarHp,
            enemyHp: newEnemyHp,
          ),
          gameResult: gameResult,
        ),
      );
    }
  }

  Future<void> _onPlayCard(PlayCard event, Emitter<CombatState> emit) async {
    print(
      'CombatBloc - Playing card: ${event.card.nome} (id: ${event.card.id}), valor: ${event.card.valor}, efeito: ${event.card.tipoEfeito}',
    );

    if (!state.isPlayerTurn || state.combat == null) {
      print('CombatBloc - Cannot play card: Not player turn or combat not initialized');
      return;
    }

    int updatedEnemyHp = state.combat!.enemyHp;
    int updatedAvatarHp = state.combat!.avatarHp;

    CombatState newState = state;

    switch (event.card.tipoEfeito) {
      case TipoEfeito.DANO:
        updatedEnemyHp = _updateHp(updatedEnemyHp, event.card.valor);
        break;
      case TipoEfeito.CURA:
        updatedAvatarHp += event.card.valor;
        final maxHp = state.combat!.avatar.hp;
        updatedAvatarHp = updatedAvatarHp.clamp(0, maxHp);
        break;
      case TipoEfeito.ESCUDO:
        print('CombatBloc - ESCUDO não implementado ainda.');
        break;
      case TipoEfeito.VENENO:
        if (state.venenoInimigoTurnos > 0) {
          newState = state.copyWith(
            venenoInimigoTurnos: state.venenoInimigoTurnos + event.card.qtdTurnos,
            venenoInimigoValor: event.card.valor,
          );
        } else {
          newState = state.copyWith(
            venenoInimigoTurnos: event.card.qtdTurnos,
            venenoInimigoValor: event.card.valor,
          );
        }
        break;
      case TipoEfeito.BUFF:
      case TipoEfeito.DEBUFF:
        print('CombatBloc - BUFF/DEBUFF não implementado ainda.');
        break;
    }

    final updatedCombat = state.combat!.copyWith(
      avatarHp: updatedAvatarHp,
      enemyHp: updatedEnemyHp,
    );

    final updatedMaoAvatar = List<Cards>.from(state.maoAvatar)..removeAt(event.cardIndex);
    final updatedDeckAvatar = List<Cards>.from(state.deckAvatar)..add(event.card);

    emit(newState.copyWith(
      combat: updatedCombat,
      maoAvatar: updatedMaoAvatar,
      deckAvatar: updatedDeckAvatar,
    ));

    print(
      'CombatBloc - Card played. New enemy HP: $updatedEnemyHp, new avatar HP: $updatedAvatarHp, hand size: ${updatedMaoAvatar.length}',
    );

    if (updatedEnemyHp <= 0) {
      print('CombatBloc - Enemy defeated!');
      _inimigosDerrotados.add(state.currentEnemy!.id); // Registrar inimigo derrotado
      if (state.isDungeon) {
        add(NextWave());
      } else {
        emit(newState.copyWith(gameResult: 'victory'));
      }
    }
  }

  Future<void> _onPlayEnemyCard(PlayEnemyCard event, Emitter<CombatState> emit) async {
    print(
      'CombatBloc - Enemy playing card: ${event.card.nome} (id: ${event.card.id}), valor: ${event.card.valor}, tipoEfeito: ${event.card.tipoEfeito}',
    );

    if (state.isPlayerTurn || state.combat == null) {
      print('CombatBloc - Cannot play enemy card: Not enemy turn or combat not initialized');
      return;
    }

    int updatedAvatarHp = state.combat!.avatarHp;
    int updatedEnemyHp = state.combat!.enemyHp;

    CombatState newState = state;

    switch (event.card.tipoEfeito) {
      case TipoEfeito.DANO:
        updatedAvatarHp = _updateHp(updatedAvatarHp, event.card.valor);
        break;
      case TipoEfeito.CURA:
        updatedEnemyHp += event.card.valor;
        final maxHp = state.combat!.enemy.hp;
        updatedEnemyHp = updatedEnemyHp.clamp(0, maxHp);
        break;
      case TipoEfeito.ESCUDO:
        print('CombatBloc - ESCUDO não implementado ainda.');
        break;
      case TipoEfeito.VENENO:
        newState = state.copyWith(
          venenoAvatarTurnos: event.card.qtdTurnos,
          venenoAvatarValor: event.card.valor,
        );
        break;
      case TipoEfeito.BUFF:
      case TipoEfeito.DEBUFF:
        print('CombatBloc - BUFF/DEBUFF não implementado ainda.');
        break;
    }

    final updatedCombat = state.combat!.copyWith(
      avatarHp: updatedAvatarHp,
      enemyHp: updatedEnemyHp,
    );

    final updatedMaoInimigo = List<Cards>.from(state.maoInimigo)..removeAt(event.cardIndex);
    final updatedDeckInimigo = List<Cards>.from(state.deckInimigo)..add(event.card);

    emit(newState.copyWith(
      combat: updatedCombat,
      maoInimigo: updatedMaoInimigo,
      deckInimigo: updatedDeckInimigo,
    ));

    print(
      'CombatBloc - Enemy card played. New avatar HP: $updatedAvatarHp, new enemy HP: $updatedEnemyHp, hand size: ${updatedMaoInimigo.length}',
    );

    if (updatedAvatarHp <= 0) {
      print('CombatBloc - Player defeated!');
      if (state.isDungeon) {
        add(EndDungeon(false));
      } else {
        emit(newState.copyWith(gameResult: 'defeat'));
      }
    }
  }

  Future<void> _onEndEnemyTurn(EndEnemyTurn event, Emitter<CombatState> emit) async {
    print(
      'CombatBloc - Ending enemy turn, current state: isPlayerTurn=${state.isPlayerTurn}, '
      'playerTurnCount=${state.playerTurnCount}, enemyTurnCount=${state.enemyTurnCount}, '
      'avatar hand=${state.maoAvatar.length} cards, enemy hand=${state.maoInimigo.length} cards',
    );

    if (!state.isPlayerTurn) {
      final newPlayerTurnCount = state.playerTurnCount + 1;
      final result = _drawCards(
        currentHand: state.maoAvatar,
        originalDeck: state.deckAvatar,
        cardsToDraw: 3,
        notifyOverflow: true,
      );

      print(
        'CombatBloc - Player drew ${result.hand.length - state.maoAvatar.length} cards, '
        'new avatar hand: ${result.hand.length} cards',
      );

      emit(
        state.copyWith(
          isPlayerTurn: true,
          playerTurnCount: newPlayerTurnCount,
          maoAvatar: result.hand,
        ),
      );
      print(
        'CombatBloc - Turn passed to player, new state: isPlayerTurn=${state.isPlayerTurn}, '
        'playerTurnCount=${state.playerTurnCount}, '
        'avatar hand=${state.maoAvatar.length} cards, enemy hand=${state.maoInimigo.length} cards',
      );
    }
  }

  Future<void> _onStartDungeonCombat(StartDungeonCombat event, Emitter<CombatState> emit) async {
    print('CombatBloc - Starting dungeon combat: playerId=${event.playerId}, dungeonId=${event.dungeonId}');

    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Buscar dados da dungeon
      final dungeons = await apiService.fetchDungeons();
      final dungeon = dungeons.firstWhere((d) => d.id == event.dungeonId);
      final totalWaves = dungeon.qtdWaves;

      // Buscar todos os inimigos disponíveis
      _allEnemies = await apiService.fetchAllEnemies();
      if (_allEnemies.isEmpty) {
        throw Exception('Nenhum inimigo disponível para a dungeon.');
      }
      _inimigosDerrotados.clear(); // Resetar lista de derrotados

      // Iniciar a primeira wave
      final initialData = await apiService.iniciarDungeon(event.playerId, event.dungeonId);
      final combat = Combat.fromInitialData(initialData);

      final List<Cards> deckAvatar = List.from(initialData.avatar.deck);
      final result = _drawCards(
        currentHand: [],
        originalDeck: deckAvatar,
        cardsToDraw: 5,
      );

      final List<Cards> maoAvatar = result.hand;
      final List<Cards> deckInimigo = List.from(initialData.enemy.deck);
      final List<Cards> maoInimigo = [];

      emit(state.copyWith(
        isLoading: false,
        combat: combat,
        maoAvatar: maoAvatar,
        maoInimigo: maoInimigo,
        deckAvatar: deckAvatar,
        deckInimigo: deckInimigo,
        isDungeon: true,
        dungeonId: event.dungeonId,
        currentWave: 1,
        totalWaves: totalWaves,
        currentEnemy: initialData.enemy,
        error: null,
      ));
    } catch (e) {
      print('CombatBloc - Error starting dungeon combat: $e');
      emit(state.copyWith(
        isLoading: false,
        error: 'Erro ao iniciar combate na dungeon: $e',
      ));
    }
  }

  Future<void> _onNextWave(NextWave event, Emitter<CombatState> emit) async {
    print('CombatBloc - Advancing to next wave. Current wave: ${state.currentWave}');

    if (state.currentWave >= state.totalWaves) {
      add(EndDungeon(true));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final nextWaveNumber = state.currentWave + 1;
      // Escolher um novo inimigo aleatório localmente
      final novoInimigo = _escolherInimigoAleatorio();

      // Simular um novo estado de combate com o novo inimigo
      final List<Cards> deckAvatar = List.from(state.deckAvatar);
      final result = _drawCards(
        currentHand: state.maoAvatar,
        originalDeck: deckAvatar,
        cardsToDraw: 3,
      );

      final List<Cards> maoAvatar = result.hand;
      final List<Cards> deckInimigo = List.from(novoInimigo.deck);
      final List<Cards> maoInimigo = [];

      // Resetar o combate para o novo inimigo
      final novoCombat = Combat(
        avatar: state.combat!.avatar,
        enemy: novoInimigo,
        avatarHp: state.combat!.avatar.hp,
        enemyHp: novoInimigo.hp,
        currentTurn: state.combat!.currentTurn,
        isCombatActive: true,
        playerWon: false,
        playerLost: false,
      );


      emit(state.copyWith(
        isLoading: false,
        combat: novoCombat,
        maoAvatar: maoAvatar,
        maoInimigo: maoInimigo,
        deckInimigo: deckInimigo,
        currentWave: nextWaveNumber,
        currentEnemy: novoInimigo,
        isPlayerTurn: true,
        playerTurnCount: 0,
        enemyTurnCount: 0,
        venenoAvatarTurnos: 0,
        venenoAvatarValor: 0,
        venenoInimigoTurnos: 0,
        venenoInimigoValor: 0,
        error: null,
      ));
    } catch (e) {
      print('CombatBloc - Error advancing to next wave: $e');
      emit(state.copyWith(
        isLoading: false,
        error: 'Erro ao avançar para a próxima wave: $e',
      ));
    }
  }

  Future<void> _onEndDungeon(EndDungeon event, Emitter<CombatState> emit) async {
    print('CombatBloc - Ending dungeon. Victory: ${event.victory}');
    emit(state.copyWith(
      gameResult: event.victory ? 'victory' : 'defeat',
    ));

    if (!event.victory) {
      // Reiniciar a dungeon
      _inimigosDerrotados.clear(); // Resetar lista de derrotados
      add(StartDungeonCombat(state.dungeonId.toString(), state.dungeonId!));
    }
  }
}