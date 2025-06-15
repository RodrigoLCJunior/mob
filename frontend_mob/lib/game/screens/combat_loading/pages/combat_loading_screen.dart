import 'package:flutter/material.dart';
import 'package:midnight_never_end/domain/entities/combat/combat_initial_data.dart';
import 'package:midnight_never_end/domain/entities/user/user_entity.dart';
import 'package:midnight_never_end/game/bloc/combat/combat_bloc.dart';
import 'package:midnight_never_end/game/bloc/combat/combat_view_model.dart';
import 'package:midnight_never_end/game/game/combat/combat_game.dart';
import 'package:midnight_never_end/game/screens/combat_loading/widgets/combat_loading_ui_widget.dart';
import 'package:midnight_never_end/game/screens/combat_loading/widgets/combat_transition_widget.dart';

class CombatLoadingScreen extends StatelessWidget {
  final CombatInitialData combatData;
  final Usuario usuario;

  const CombatLoadingScreen({
    required this.combatData,
    required this.usuario,
    super.key,
  });

  Future<void> _waitForGameLoadAndNavigate(BuildContext context) async {
    try {
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

      // Wait until loading is complete with a timeout
      await Future.any([
        Future.doWhile(() async {
          if (game.isComponentsLoaded && game.isAnimationComplete) return false;
          await Future.delayed(const Duration(milliseconds: 100));
          return true;
        }),
        Future.delayed(const Duration(seconds: 10), () {
          throw Exception('Timeout: Loading exceeded 10 seconds');
        }),
      ]);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          CombatTransition(combatData: combatData, usuario: usuario),
        );
      }

      // Clean up
      viewModel.dispose();
      combatBloc.close();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e. Please try again.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trigger navigation logic
    _waitForGameLoadAndNavigate(context);
    return const CombatLoadingUI();
  }
}
