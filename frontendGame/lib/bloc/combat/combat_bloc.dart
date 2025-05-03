/// Este arquivo define a classe `CombatBloc`, responsável por gerenciar a lógica de combate
/// em um jogo de cartas baseado em turnos usando o padrão BLoC (Business Logic Component).
///
/// Eventos tratados:
/// - `InitializeCombat`: Inicializa o estado do combate com os dados fornecidos (decks e vida dos personagens).
/// - `PassTurn`: Alterna entre o turno do jogador e do inimigo, e o inimigo adiciona 5 novas cartas à mão.
/// - `PlayCard`: O jogador joga uma carta; reduz a vida do inimigo, retorna a carta ao deck e verifica se o inimigo foi derrotado.
/// - `PlayEnemyCard`: O inimigo joga uma carta; reduz a vida do jogador, retorna a carta ao deck e verifica se o jogador foi derrotado.
/// - `EndEnemyTurn`: Finaliza o turno do inimigo, o jogador adiciona 5 novas cartas à mão, e inicia o turno do jogador.
///
/// Detalhes:
/// - A mão inicial de cada jogador contém 5 cartas aleatórias, selecionadas a partir de uma cópia do respectivo deck.
/// - A cada turno, o jogador (ou inimigo) adiciona 5 novas cartas à sua mão, criando cópias das cartas do deck com novos `id`s únicos.
/// - Um contador global (`_cardIdCounter`) é usado para gerar `id`s únicos para cada carta copiada, incrementando o contador a cada nova carta.
/// - O deck original do jogador e do inimigo permanece inalterado durante o jogo (exceto quando cartas jogadas são adicionadas de volta).
/// - Quando uma carta é jogada, ela é retornada ao deck correspondente.
/// - O BLoC gerencia o `CombatState`, que armazena as mãos, decks, pontos de vida, turnos e resultado do jogo.
///
/// Uso:
/// A classe `CombatBloc` deve ser usada em conjunto com a UI e o `CombatViewModel`, permitindo
/// uma separação clara entre interface e lógica de negócios no Flutter.

import 'package:bloc/bloc.dart';
import 'package:midnight_never_end/models/combat.dart';
import 'package:midnight_never_end/models/card.dart';
import 'combat_event.dart';
import 'combat_state.dart';
import 'dart:math' as math;

class CombatBloc extends Bloc<CombatEvent, CombatState> {
  // Contador global para turnos
  int _turnGlobalCounter = 1;

  // Contador global para gerar `id`s únicos para cartas copiadas
  int _cardIdCounter = 0;

  CombatBloc() : super(CombatState.initial()) {
    on<InitializeCombat>(_onInitializeCombat);
    on<PassTurn>(_onPassTurn);
    on<PlayCard>(_onPlayCard);
    on<PlayEnemyCard>(_onPlayEnemyCard);
    on<EndEnemyTurn>(_onEndEnemyTurn);
  }

  // --- Funções Auxiliares ---

  /// Cria uma cópia de uma carta com um novo `id` único.
  Cards _copyCardWithNewId(Cards card) {
    _cardIdCounter++;
    return Cards(id: _cardIdCounter, nome: card.nome, damage: card.damage);
  }

  /// Compra um número específico de cartas de um deck, reabastecendo-o se necessário.
  List<Cards> _drawCards({
    required List<Cards> currentHand,
    required List<Cards> originalDeck,
    required int cardsToDraw,
  }) {
    final newHand = List<Cards>.from(currentHand);
    final deckCopy = List<Cards>.from(originalDeck);
    final random = math.Random();

    for (int i = 0; i < cardsToDraw; i++) {
      if (deckCopy.isEmpty) {
        if (originalDeck.isEmpty) break;
        deckCopy.addAll(originalDeck);
      }
      final index = random.nextInt(deckCopy.length);
      final selectedCard = deckCopy[index];
      newHand.add(_copyCardWithNewId(selectedCard));
      deckCopy.removeAt(index);
    }

    return newHand;
  }

  /// Atualiza a vida de um personagem, garantindo que não seja menor que 0.
  int _updateHp(int currentHp, int damage) {
    final newHp = currentHp - damage;
    return newHp < 0 ? 0 : newHp;
  }

  // --- Manipuladores de Eventos ---

  /// Inicializa o combate com os dados fornecidos.
  Future<void> _onInitializeCombat(
    InitializeCombat event,
    Emitter<CombatState> emit,
  ) async {
    print('CombatBloc - Initializing combat with data: ${event.initialData}');

    // Resetar o contador global de turnos
    _turnGlobalCounter = 1;

    // Resetar o contador global de IDs de cartas
    _cardIdCounter = 0;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Criar o objeto de combate
      final combat = Combat.fromInitialData(event.initialData);
      print(
        'CombatBloc - Combat initialized: avatarHp=${combat.avatarHp}, enemyHp=${combat.enemyHp}',
      );

      // Inicializar o deck e a mão do avatar
      final List<Cards> deckAvatar = List.from(event.initialData.avatar.deck);
      final List<Cards> maoAvatar = _drawCards(
        currentHand: [],
        originalDeck: deckAvatar,
        cardsToDraw: 5,
      );
      // deckAvatarCopy.removeAt(index); // Comentado para permitir duplicatas
      print('CombatBloc - Avatar hand: ${maoAvatar.length} cards');

      // Inicializar o deck do inimigo (mão inicia vazia)
      final List<Cards> deckInimigo = List.from(event.initialData.enemy.deck);
      final List<Cards> maoInimigo = [];

      // Emitir o novo estado
      emit(
        state.copyWith(
          isLoading: false,
          combat: combat,
          maoAvatar: maoAvatar,
          maoInimigo: maoInimigo,
          deckAvatar: deckAvatar,
          deckInimigo: deckInimigo,
          error: null,
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

  /// Alterna o turno entre jogador e inimigo, comprando cartas para o próximo turno.
  Future<void> _onPassTurn(PassTurn event, Emitter<CombatState> emit) async {
    print(
      'CombatBloc - Passing turn. Current state: isPlayerTurn=${state.isPlayerTurn}, '
      'playerTurnCount=${state.playerTurnCount}, enemyTurnCount=${state.enemyTurnCount}, '
      'avatar hand=${state.maoAvatar.length} cards, enemy hand=${state.maoInimigo.length} cards',
    );

    // Incrementar o contador global de turnos
    _turnGlobalCounter++;
    print('CombatBloc - Turn global counter: $_turnGlobalCounter');

    if (state.isPlayerTurn) {
      // Passar para o turno do inimigo
      final newEnemyTurnCount = state.enemyTurnCount + 1;
      final cardsToDraw =
          _turnGlobalCounter == 2
              ? 5
              : 3; // 5 cartas no primeiro turno do inimigo
      final newMaoInimigo = _drawCards(
        currentHand: state.maoInimigo,
        originalDeck: state.deckInimigo,
        cardsToDraw: cardsToDraw,
      );

      print(
        'CombatBloc - Enemy drew ${newMaoInimigo.length - state.maoInimigo.length} cards, '
        'new enemy hand: ${newMaoInimigo.length} cards',
      );

      emit(
        state.copyWith(
          isPlayerTurn: false,
          enemyTurnCount: newEnemyTurnCount,
          maoInimigo: newMaoInimigo,
        ),
      );
      print(
        'CombatBloc - Turn passed to enemy, new state: isPlayerTurn=${state.isPlayerTurn}, '
        'enemyTurnCount=${state.enemyTurnCount}, '
        'avatar hand=${state.maoAvatar.length} cards, enemy hand=${state.maoInimigo.length} cards',
      );
    } else {
      // Passar para o turno do jogador
      final newPlayerTurnCount = state.playerTurnCount + 1;
      final newMaoAvatar = _drawCards(
        currentHand: state.maoAvatar,
        originalDeck: state.deckAvatar,
        cardsToDraw: 3,
      );

      print(
        'CombatBloc - Player drew ${newMaoAvatar.length - state.maoAvatar.length} cards, '
        'new avatar hand: ${newMaoAvatar.length} cards',
      );

      emit(
        state.copyWith(
          isPlayerTurn: true,
          playerTurnCount: newPlayerTurnCount,
          maoAvatar: newMaoAvatar,
        ),
      );
      print(
        'CombatBloc - Turn passed to player, new state: isPlayerTurn=${state.isPlayerTurn}, '
        'playerTurnCount=${state.playerTurnCount}, '
        'avatar hand=${state.maoAvatar.length} cards, enemy hand=${state.maoInimigo.length} cards',
      );
    }
  }

  /// Processa o jogador jogando uma carta contra o inimigo.
  Future<void> _onPlayCard(PlayCard event, Emitter<CombatState> emit) async {
    print(
      'CombatBloc - Playing card: ${event.card.nome} (id: ${event.card.id}), damage: ${event.card.damage}',
    );

    if (!state.isPlayerTurn || state.combat == null) {
      print(
        'CombatBloc - Cannot play card: Not player turn or combat not initialized',
      );
      return;
    }

    // Calcular o novo HP do inimigo
    final updatedEnemyHp = _updateHp(state.combat!.enemyHp, event.card.damage);
    final updatedCombat = state.combat!.copyWith(enemyHp: updatedEnemyHp);

    // Remover a carta da mão do avatar e adicionar de volta ao deck
    final updatedMaoAvatar = List<Cards>.from(state.maoAvatar)
      ..removeAt(event.cardIndex);
    final updatedDeckAvatar = List<Cards>.from(state.deckAvatar)
      ..add(event.card);

    emit(
      state.copyWith(
        combat: updatedCombat,
        maoAvatar: updatedMaoAvatar,
        deckAvatar: updatedDeckAvatar,
      ),
    );

    print(
      'CombatBloc - Card played. New enemy HP: $updatedEnemyHp, '
      'new avatar hand: ${updatedMaoAvatar.length} cards',
    );

    // Verificar se o inimigo foi derrotado
    if (updatedEnemyHp <= 0) {
      print('CombatBloc - Enemy defeated!');
      emit(state.copyWith(gameResult: 'victory'));
    }
  }

  /// Processa o inimigo jogando uma carta contra o jogador.
  Future<void> _onPlayEnemyCard(
    PlayEnemyCard event,
    Emitter<CombatState> emit,
  ) async {
    print(
      'CombatBloc - Enemy playing card: ${event.card.nome} (id: ${event.card.id}), damage: ${event.card.damage}',
    );

    if (state.isPlayerTurn || state.combat == null) {
      print(
        'CombatBloc - Cannot play enemy card: Not enemy turn or combat not initialized',
      );
      return;
    }

    // Calcular o novo HP do avatar
    final updatedAvatarHp = _updateHp(
      state.combat!.avatarHp,
      event.card.damage,
    );
    final updatedCombat = state.combat!.copyWith(avatarHp: updatedAvatarHp);

    // Remover a carta da mão do inimigo e adicionar de volta ao deck
    final updatedMaoInimigo = List<Cards>.from(state.maoInimigo)
      ..removeAt(event.cardIndex);
    final updatedDeckInimigo = List<Cards>.from(state.deckInimigo)
      ..add(event.card);

    emit(
      state.copyWith(
        combat: updatedCombat,
        maoInimigo: updatedMaoInimigo,
        deckInimigo: updatedDeckInimigo,
      ),
    );

    print(
      'CombatBloc - Enemy card played. New avatar HP: $updatedAvatarHp, '
      'new enemy hand: ${updatedMaoInimigo.length} cards',
    );

    // Verificar se o jogador foi derrotado
    if (updatedAvatarHp <= 0) {
      print('CombatBloc - Player defeated!');
      emit(state.copyWith(gameResult: 'defeat'));
    }
  }

  /// Finaliza o turno do inimigo e passa para o jogador, comprando cartas para o jogador.
  Future<void> _onEndEnemyTurn(
    EndEnemyTurn event,
    Emitter<CombatState> emit,
  ) async {
    print(
      'CombatBloc - Ending enemy turn, current state: isPlayerTurn=${state.isPlayerTurn}, '
      'playerTurnCount=${state.playerTurnCount}, enemyTurnCount=${state.enemyTurnCount}, '
      'avatar hand=${state.maoAvatar.length} cards, enemy hand=${state.maoInimigo.length} cards',
    );

    if (!state.isPlayerTurn) {
      // Passar para o turno do jogador
      final newPlayerTurnCount = state.playerTurnCount + 1;
      final newMaoAvatar = _drawCards(
        currentHand: state.maoAvatar,
        originalDeck: state.deckAvatar,
        cardsToDraw: 3,
      );

      print(
        'CombatBloc - Player drew ${newMaoAvatar.length - state.maoAvatar.length} cards, '
        'new avatar hand: ${newMaoAvatar.length} cards',
      );

      emit(
        state.copyWith(
          isPlayerTurn: true,
          playerTurnCount: newPlayerTurnCount,
          maoAvatar: newMaoAvatar,
        ),
      );
      print(
        'CombatBloc - Turn passed to player, new state: isPlayerTurn=${state.isPlayerTurn}, '
        'playerTurnCount=${state.playerTurnCount}, '
        'avatar hand=${state.maoAvatar.length} cards, enemy hand=${state.maoInimigo.length} cards',
      );
    }
  }
}
