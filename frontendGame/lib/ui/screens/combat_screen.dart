import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:midnight_never_end/bloc/combat/combat_bloc.dart';
import 'package:midnight_never_end/bloc/combat/combat_state.dart';
import 'package:midnight_never_end/bloc/combat/combat_view_model.dart';
import 'package:midnight_never_end/models/combat_initial_data.dart';
import 'package:midnight_never_end/models/usuario.dart';
import 'package:midnight_never_end/ui/game/combat_game.dart';

class CombatScreen extends StatefulWidget {
  final Usuario usuario;
  final CombatInitialData combatData;

  const CombatScreen({
    Key? key,
    required this.usuario,
    required this.combatData,
  }) : super(key: key);

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  late CombatBloc _combatBloc;
  late CombatViewModel _viewModel;
  late CombatGame _game;
  bool _isInitialAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    // Inicializar o CombatBloc e CombatViewModel
    _combatBloc = CombatBloc();
    _viewModel = CombatViewModel(_combatBloc);
    _viewModel.initialize(widget.combatData);
    print('CombatScreen - Initialized CombatViewModel with combatData');

    // Inicializar o CombatGame
    _game = CombatGame(
      combatData: widget.combatData,
      usuario: widget.usuario,
      viewModel: _viewModel,
      context: context, // Passando o BuildContext para o CombatGame
      onAnimationComplete: () {
        print('CombatScreen - Initial animation complete');
        setState(() {
          _isInitialAnimationComplete = true;
        });
      },
    );

    // Forçar a inicialização do jogo após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      _game.onGameResize(Vector2(screenSize.width, screenSize.height));
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _combatBloc.close(); // Fechar o CombatBloc para evitar vazamentos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<CombatState>(
        stream: _viewModel.combatStateStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final state = snapshot.data!;
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Erro: ${state.error}'));
          }

          if (state.combat == null) {
            return const Center(child: Text('Combate não inicializado'));
          }

          return Stack(
            children: [
              // GameWidget para renderizar o jogo
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: GameWidget(game: _game),
                  );
                },
              ),
              // Indicador de turno no topo
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            state.isPlayerTurn
                                ? const Color(
                                  0xFF00FF00,
                                ) // Verde para turno do jogador
                                : const Color(
                                  0xFFFF0000,
                                ), // Vermelho para turno do inimigo
                        width: 2,
                      ),
                    ),
                    child: Text(
                      state.isPlayerTurn
                          ? 'Turno do Jogador'
                          : 'Turno do Inimigo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // Botão "Passar Turno" no canto inferior direito
              Positioned(
                bottom: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed:
                      (_isInitialAnimationComplete && state.isPlayerTurn)
                          ? () {
                            _viewModel.passTurn();
                            print('CombatScreen - PassTurn button pressed');
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (_isInitialAnimationComplete && state.isPlayerTurn)
                            ? const Color(0xFF8B0000)
                            : Colors.grey.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Color(0xFFDAA520),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    'Passar Turno',
                    style: TextStyle(
                      color:
                          (_isInitialAnimationComplete && state.isPlayerTurn)
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
