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
    _combatBloc = CombatBloc();
    _viewModel = CombatViewModel(_combatBloc);
    _viewModel.initialize(widget.combatData);
    print('CombatScreen - Initialized CombatViewModel with combatData');

    _game = CombatGame(
      combatData: widget.combatData,
      usuario: widget.usuario,
      viewModel: _viewModel,
      context: context,
      onAnimationComplete: () {
        print('CombatScreen - Initial animation complete');
        setState(() {
          _isInitialAnimationComplete = true;
        });
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      _game.onGameResize(Vector2(screenSize.width, screenSize.height));
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _combatBloc.close();
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

          final screenHeight = MediaQuery.of(context).size.height;

          return Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: GameWidget(game: _game),
                  );
                },
              ),
              // Indicador de turno no topo, afastado para baixo
              Positioned(
                top: screenHeight * 0.05,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenHeight * 0.02,
                      vertical: screenHeight * 0.015,
                    ),
                    decoration: BoxDecoration(
                      color:
                          state.isPlayerTurn
                              ? const Color(0xFF155250)
                              : const Color(0xFF2A1A3D),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      state.isPlayerTurn
                          ? 'Turno do Jogador'
                          : 'Turno do Inimigo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.025,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Botão "Passar Turno" no canto inferior direito, 2x menor
              Positioned(
                bottom: screenHeight * 0.05,
                right: screenHeight * 0.02,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        (_isInitialAnimationComplete && state.isPlayerTurn)
                            ? const Color(0xFF155250)
                            : Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed:
                        (_isInitialAnimationComplete && state.isPlayerTurn)
                            ? () {
                              _viewModel.passTurn();
                              print('CombatScreen - PassTurn button pressed');
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenHeight * 0.0125, // Metade de 0.025
                        vertical: screenHeight * 0.0075, // Metade de 0.015
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Passar Turno',
                      style: TextStyle(
                        color:
                            (_isInitialAnimationComplete && state.isPlayerTurn)
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                        fontSize: screenHeight * 0.011, // Metade de 0.022
                        fontWeight: FontWeight.bold,
                      ),
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
