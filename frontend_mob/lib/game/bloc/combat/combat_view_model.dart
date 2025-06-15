// CombatViewModel - ViewModel responsável por gerenciar o estado e a lógica do combate no jogo Midnight Never End.
//
// O CombatViewModel se comunica com o CombatBloc, que contém a lógica de negócios do combate, e atualiza a interface de usuário
// quando o estado do combate muda. Ele utiliza o padrão ChangeNotifier para notificar a UI sobre alterações no estado do combate.
//
// **Fluxo de Funcionamento**:
//    - O CombatViewModel se inscreve no CombatBloc e atualiza a UI sempre que o estado do combate muda.
//    - O ViewModel emite eventos para o CombatBloc, como `InitializeCombat`, `PlayCard`, `PassTurn`, etc., para manipular a lógica de combate.
//    - O CombatBloc, por sua vez, atualiza o estado do combate de acordo com os eventos recebidos, e o ViewModel notifica a UI sobre essas mudanças.
//
// **Métodos Importantes**:
//    - `initialize(CombatInitialData initialData)`: Inicializa o combate com os dados fornecidos.
//    - `passTurn()`: Envia o evento para passar o turno do jogador.
//    - `playCard(Cards card, int cardIndex)`: Envia o evento para jogar uma carta do jogador.
//    - `playEnemyCard(Cards card, int cardIndex)`: Envia o evento para o inimigo jogar uma carta.
//    - `endEnemyTurn()`: Envia o evento para finalizar o turno do inimigo.
//
// **Gerenciamento de Estado**:
//    - O CombatViewModel mantém o estado atual do combate, e sempre que o estado do combate muda, ele notifica a UI utilizando o `notifyListeners()`.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:midnight_never_end/domain/entities/cards/cards_entity.dart';
import 'package:midnight_never_end/domain/entities/combat/combat_initial_data.dart';
import 'package:midnight_never_end/game/bloc/combat/combat_bloc.dart';
import 'package:midnight_never_end/game/bloc/combat/combat_event.dart';
import 'package:midnight_never_end/game/bloc/combat/combat_state.dart';

class CombatViewModel extends ChangeNotifier {
  final CombatBloc _combatBloc;
  StreamSubscription<CombatState>? _stateSubscription;

  CombatViewModel(this._combatBloc) {
    _stateSubscription = _combatBloc.stream.listen((state) {
      notifyListeners();
    });
  }

  CombatState get state => _combatBloc.state;

  Stream<CombatState> get combatStateStream => _combatBloc.stream;

  void initialize(CombatInitialData initialData) {
    _combatBloc.add(InitializeCombat(initialData));
  }

  void passTurn() {
    _combatBloc.add(PassTurn());
  }

  void playCard(Cards card, int cardIndex) {
    _combatBloc.add(PlayCard(card, cardIndex));
  }

  void playEnemyCard(Cards card, int cardIndex) {
    _combatBloc.add(PlayEnemyCard(card, cardIndex));
  }

  void endEnemyTurn() {
    _combatBloc.add(EndEnemyTurn());
  }

  void clearStatusMessage() {
    _combatBloc.add(ClearStatusMessage());
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _combatBloc.close();
    super.dispose();
  }
}
