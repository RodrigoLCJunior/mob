import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:midnight_never_end/domain/entities/combat/combat_initial_data.dart';
import 'package:midnight_never_end/domain/entities/user/user_entity.dart';
import 'package:midnight_never_end/game/bloc/combat/combat_bloc.dart';
import 'package:midnight_never_end/game/bloc/combat/combat_state.dart';
import 'package:midnight_never_end/game/bloc/combat/combat_view_model.dart';
import 'package:midnight_never_end/game/game/combat/combat_game.dart';
import 'package:midnight_never_end/game/screens/combat/widgets/combat_back_button_widget.dart';
import 'package:midnight_never_end/game/screens/combat/widgets/combat_error_widget.dart';
import 'package:midnight_never_end/game/screens/combat/widgets/combat_game_widget.dart';
import 'package:midnight_never_end/game/screens/combat/widgets/combat_loading_widget.dart';
import 'package:midnight_never_end/game/screens/combat/widgets/combat_pass_turn_button_widget.dart';
import 'package:midnight_never_end/game/screens/combat/widgets/combat_turn_indicator_widget.dart';
import 'package:midnight_never_end/game/screens/combat/widgets/combat_uninitialized_widget.dart';

class CombatScreen extends StatelessWidget {
  final Usuario usuario;
  final CombatInitialData combatData;

  const CombatScreen({
    super.key,
    required this.usuario,
    required this.combatData,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize CombatBloc and CombatViewModel
    final combatBloc = CombatBloc();
    final viewModel = CombatViewModel(combatBloc);
    viewModel.initialize(combatData);

    // Initialize CombatGame
    final game = CombatGame(
      combatData: combatData,
      usuario: usuario,
      viewModel: viewModel,
      context: context,
      onAnimationComplete: () {},
    );

    // Resize game after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      game.onGameResize(Vector2(screenSize.width, screenSize.height));
    });

    return Scaffold(
      body: StreamBuilder<CombatState>(
        stream: viewModel.combatStateStream,
        builder: (context, snapshot) {
          // Clean up when the widget is removed
          if (!context.mounted) {
            viewModel.dispose();
            combatBloc.close();
            return const SizedBox.shrink();
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return const CombatLoadingWidget();
          }

          final state = snapshot.data!;

          if (state.isLoading) {
            return const CombatLoadingWidget();
          }

          if (state.error != null) {
            return CombatErrorWidget(error: state.error!);
          }

          if (state.combat == null) {
            return const CombatUninitializedWidget();
          }

          return Stack(
            children: [
              CombatGameWidget(game: game),
              CombatTurnIndicator(isPlayerTurn: state.isPlayerTurn),
              CombatBackButton(isPlayerTurn: state.isPlayerTurn),
              CombatPassTurnButton(
                isPlayerTurn: state.isPlayerTurn,
                onPassTurn: viewModel.passTurn,
              ),
            ],
          );
        },
      ),
    );
  }
}
