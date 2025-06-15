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

//
//Angelo: Alteracao na funcao de criar copia de carta, onPlayCard e onPlayEnemyCard para suportar novo formato de carta com enum
//
import 'package:bloc/bloc.dart';
import 'package:midnight_never_end/domain/entities/cards/cards_entity.dart';
import 'package:midnight_never_end/domain/entities/combat/combat_entity.dart';
import 'combat_event.dart';
import 'combat_state.dart';
import 'dart:math' as math;

class DrawResult {
  final List<Cards> hand;
  final String? message;
  final int? messageId;

  DrawResult(this.hand, this.message, [this.messageId]);
}

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
    on<ClearStatusMessage>(_onClearStatusMessage);
  }

  // --- Funções Auxiliares ---

  /// Cria uma cópia de uma carta com um novo `id` único.
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

  /// Compra um número específico de cartas de um deck, reabastecendo-o se necessário.
  DrawResult _drawCards({
    required List<Cards> currentHand,
    required List<Cards> originalDeck,
    required int cardsToDraw,
    bool? notifyOverflow,
  }) {
    final newHand = List<Cards>.from(currentHand);
    final deckCopy = List<Cards>.from(originalDeck);
    final random = math.Random();
    notifyOverflow ??= false;
    const maxHandSize = 12;
    String? statusMessage;

    if (newHand.length >= maxHandSize) {
      final indicesToReplace = <int>{};
      while (indicesToReplace.length < 3 &&
          indicesToReplace.length < newHand.length) {
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
        statusMessage =
            "Você atingiu o limite de 12 cartas. 3 cartas foram substituídas aleatoriamente.";
        return DrawResult(
          newHand,
          statusMessage,
          DateTime.now().millisecondsSinceEpoch,
        );
      }

      return DrawResult(newHand, null);
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
    // Resetar o contador global de turnos
    _turnGlobalCounter = 1;

    // Resetar o contador global de IDs de cartas
    _cardIdCounter = 0;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Criar o objeto de combate
      final combat = Combat.fromInitialData(event.initialData);

      // Inicializar o deck e a mão do avatar
      final List<Cards> deckAvatar = List.from(event.initialData.avatar.deck);
      final result = _drawCards(
        currentHand: [],
        originalDeck: deckAvatar,
        cardsToDraw: 5,
      );

      final List<Cards> maoAvatar = result.hand;
      // deckAvatarCopy.removeAt(index); // Comentado para permitir duplicatas

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
    } catch (e) {
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
    int newAvatarHp = state.combat?.avatarHp ?? 0;
    int newEnemyHp = state.combat?.enemyHp ?? 0;

    int venenoAvatarTurnos = state.venenoAvatarTurnos;
    int venenoInimigoTurnos = state.venenoInimigoTurnos;

    int venenoAvatarValor = state.venenoAvatarValor;
    int venenoInimigoValor = state.venenoInimigoValor;

    // Aplicar dano de veneno no início de cada turno
    if (state.isPlayerTurn && venenoInimigoTurnos > 0) {
      newEnemyHp = _updateHp(newEnemyHp, venenoInimigoValor);
      venenoInimigoTurnos--;
      if (venenoInimigoTurnos == 0) venenoInimigoValor = 0;
    } else if (!state.isPlayerTurn && venenoAvatarTurnos > 0) {
      newAvatarHp = _updateHp(newAvatarHp, venenoAvatarValor);
      venenoAvatarTurnos--;
      if (venenoAvatarTurnos == 0) venenoAvatarValor = 0;
    }

    // Verifica se alguém morreu por veneno
    String? gameResult;
    if (newEnemyHp <= 0) {
      gameResult = 'victory';
    }
    if (newAvatarHp <= 0) {
      gameResult = 'defeat';
    }

    _turnGlobalCounter++;

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
          statusMessage: result.message,
          statusMessageId: result.messageId ?? state.statusMessageId,
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
          statusMessage: result.message,
          statusMessageId: result.messageId ?? state.statusMessageId,
        ),
      );
    }
  }

  /// Processa o jogador jogando uma carta contra o inimigo.
  Future<void> _onPlayCard(PlayCard event, Emitter<CombatState> emit) async {
    if (!state.isPlayerTurn || state.combat == null) {
      return;
    }

    // Verificar se o índice e ID correspondem à mão
    if (event.cardIndex < 0 ||
        event.cardIndex >= state.maoAvatar.length ||
        state.maoAvatar[event.cardIndex].id != event.card.id) {
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
        break;
      case TipoEfeito.VENENO:
        if (state.venenoInimigoTurnos > 0) {
          newState = state.copyWith(
            venenoInimigoTurnos:
                state.venenoInimigoTurnos + event.card.qtdTurnos,
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
        break;
    }

    final updatedCombat = state.combat!.copyWith(
      enemyHp: updatedEnemyHp,
      avatarHp: updatedAvatarHp,
    );

    final updatedMaoAvatar = List<Cards>.from(state.maoAvatar)
      ..removeAt(event.cardIndex);
    final updatedDeckAvatar = List<Cards>.from(state.deckAvatar)
      ..add(event.card);

    emit(
      newState.copyWith(
        combat: updatedCombat,
        maoAvatar: updatedMaoAvatar,
        deckAvatar: updatedDeckAvatar,
      ),
    );

    if (updatedEnemyHp <= 0) {
      emit(newState.copyWith(gameResult: 'victory'));
    }
  }

  /// Processa o inimigo jogando uma carta contra o jogador.
  Future<void> _onPlayEnemyCard(
    PlayEnemyCard event,
    Emitter<CombatState> emit,
  ) async {
    if (state.isPlayerTurn || state.combat == null) {
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
        break;
      case TipoEfeito.VENENO:
        if (state.venenoAvatarTurnos > 0) {
          newState = state.copyWith(
            venenoAvatarTurnos: state.venenoAvatarTurnos + event.card.qtdTurnos,
            venenoAvatarValor: event.card.valor,
          );
        } else {
          newState = state.copyWith(
            venenoAvatarTurnos: event.card.qtdTurnos,
            venenoAvatarValor: event.card.valor,
          );
        }
        break;
      case TipoEfeito.BUFF:
        break;
      case TipoEfeito.DEBUFF:
        break;
    }

    final updatedCombat = state.combat!.copyWith(
      avatarHp: updatedAvatarHp,
      enemyHp: updatedEnemyHp,
    );

    final updatedMaoInimigo = List<Cards>.from(state.maoInimigo)
      ..removeAt(event.cardIndex);
    final updatedDeckInimigo = List<Cards>.from(state.deckInimigo)
      ..add(event.card);

    emit(
      newState.copyWith(
        combat: updatedCombat,
        maoInimigo: updatedMaoInimigo,
        deckInimigo: updatedDeckInimigo,
      ),
    );

    if (updatedAvatarHp <= 0) {
      emit(newState.copyWith(gameResult: 'defeat'));
    }
  }

  /// Finaliza o turno do inimigo e passa para o jogador, comprando cartas para o jogador.
  Future<void> _onEndEnemyTurn(
    EndEnemyTurn event,
    Emitter<CombatState> emit,
  ) async {
    if (!state.isPlayerTurn) {
      int newAvatarHp = state.combat?.avatarHp ?? 0;
      int newEnemyHp = state.combat?.enemyHp ?? 0;
      int venenoAvatarTurnos = state.venenoAvatarTurnos;
      int venenoAvatarValor = state.venenoAvatarValor;

      // Aplicar dano por veneno
      if (venenoAvatarTurnos > 0) {
        newAvatarHp = _updateHp(newAvatarHp, venenoAvatarValor);
        venenoAvatarTurnos--;
        if (venenoAvatarTurnos == 0) venenoAvatarValor = 0;
      }

      String? gameResult;
      if (newEnemyHp <= 0) {
        gameResult = 'victory';
      }
      if (newAvatarHp <= 0) {
        gameResult = 'defeat';
      }
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
          statusMessage: result.message,
          statusMessageId: result.messageId ?? state.statusMessageId,
          gameResult: gameResult,
          combat: state.combat?.copyWith(avatarHp: newAvatarHp),
          venenoAvatarTurnos: venenoAvatarTurnos,
          venenoAvatarValor: venenoAvatarValor,
        ),
      );
    }
  }

  Future<void> _onClearStatusMessage(
    ClearStatusMessage event,
    Emitter<CombatState> emit,
  ) async {
    emit(state.copyWith(statusMessage: null));
  }
}
