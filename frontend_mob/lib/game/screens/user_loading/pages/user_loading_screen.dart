import 'package:flutter/material.dart';
import 'package:midnight_never_end/data/repositories/game/game_repository.dart';
import 'package:midnight_never_end/domain/entities/combat/combat_initial_data.dart';
import 'package:midnight_never_end/domain/entities/user/user_entity.dart';
import 'package:midnight_never_end/game/screens/user_loading/widgets/user_loading_ui_widget.dart';
import 'package:midnight_never_end/game/screens/user_loading/widgets/user_transition_widget.dart';

class UserLoadingScreen extends StatelessWidget {
  final Usuario usuario;
  final GameRepository gameRepository;

  const UserLoadingScreen({
    super.key,
    required this.usuario,
    required this.gameRepository,
  });

  Future<Map<String, dynamic>> _fetchCombatData() async {
    try {
      final combatData = await gameRepository.startCombat(usuario.id);
      return {'usuario': usuario, 'combatData': combatData};
    } catch (e) {
      throw e;
    }
  }

  void _navigateToCombatScreen(
    BuildContext context,
    Usuario usuario,
    CombatInitialData combatData,
  ) {
    Navigator.push(
      context,
      UserTransition(usuario: usuario, combatData: combatData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchCombatData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const UserLoadingUI.loading();
        }

        if (snapshot.hasError) {
          return UserLoadingUI.error(
            error: snapshot.error.toString(),
            onRetry: () {
              // Trigger rebuild by creating a new Future
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => UserLoadingScreen(
                        usuario: usuario,
                        gameRepository: gameRepository,
                      ),
                ),
              );
            },
          );
        }

        if (snapshot.hasData) {
          final usuario = snapshot.data!['usuario'] as Usuario;
          final combatData = snapshot.data!['combatData'] as CombatInitialData;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigateToCombatScreen(context, usuario, combatData);
          });

          return const UserLoadingUI.loading();
        }

        return const UserLoadingUI.defaultState();
      },
    );
  }
}
