import 'package:flutter/material.dart';
import 'package:midnight_never_end/bloc/combat/combat_bloc.dart';
import 'package:midnight_never_end/bloc/combat/combat_view_model.dart';
import 'package:midnight_never_end/models/combat_initial_data.dart';
import 'package:midnight_never_end/models/usuario.dart';
import 'package:midnight_never_end/ui/game/combat_game.dart';
import 'package:midnight_never_end/ui/screens/combat_screen.dart';
import 'package:midnight_never_end/services/api_service.dart';

class CombatLoadingScreen extends StatefulWidget {
  final CombatInitialData combatData;
  final Usuario usuario;

  const CombatLoadingScreen({
    required this.combatData,
    required this.usuario,
    super.key,
  });

  @override
  State<CombatLoadingScreen> createState() => _CombatLoadingScreenState();
}

class _CombatLoadingScreenState extends State<CombatLoadingScreen> {
  late CombatGame game;
  late CombatBloc _combatBloc;
  late CombatViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Inicializar o CombatBloc e CombatViewModel
    _combatBloc = CombatBloc();
    _viewModel = CombatViewModel(_combatBloc, ApiService());
    _viewModel.initialize(widget.combatData);
    print('CombatLoadingScreen - Initialized CombatViewModel with combatData');

    // Inicializar o CombatGame
    game = CombatGame(
      combatData: widget.combatData,
      usuario: widget.usuario,
      viewModel: _viewModel,
      context: context,
      onAnimationComplete: () {
        print('CombatLoadingScreen - Initial animation complete');
      },
    );
    // Iniciar o processo de espera pelo carregamento
    _waitForGameLoadAndNavigate();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _combatBloc.close();
    super.dispose();
  }

  Future<void> _waitForGameLoadAndNavigate() async {
    try {
      print('CombatLoadingScreen - Waiting for game to load');
      // Aguardar até que o carregamento esteja completo com timeout
      await Future.any([
        Future.doWhile(() async {
          print(
            'CombatLoadingScreen - Checking load state: components=${game.isComponentsLoaded}, animation=${game.isAnimationComplete}',
          );
          if (game.isComponentsLoaded && game.isAnimationComplete) return false;
          await Future.delayed(const Duration(milliseconds: 100));
          return true;
        }),
        Future.delayed(const Duration(seconds: 10), () {
          throw Exception('Timeout: Carregamento excedeu 10 segundos');
        }),
      ]);
      print(
        'CombatLoadingScreen - Game fully loaded, navigating to CombatScreen',
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => CombatScreen(
                  usuario: widget.usuario,
                  combatData: widget.combatData,
                ),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const curve = Curves.easeInOut;
              var fadeTween = Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).chain(CurveTween(curve: curve));
              var scaleTween = Tween<double>(
                begin: 0.95,
                end: 1.0,
              ).chain(CurveTween(curve: curve));

              return Stack(
                children: [
                  FadeTransition(
                    opacity: animation.drive(
                      Tween<double>(
                        begin: 1.0,
                        end: 0.0,
                      ).chain(CurveTween(curve: curve)),
                    ),
                    child: Container(color: Colors.black.withOpacity(0.8)),
                  ),
                  FadeTransition(
                    opacity: animation.drive(fadeTween),
                    child: ScaleTransition(
                      scale: animation.drive(scaleTween),
                      child: child,
                    ),
                  ),
                ],
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      print('CombatLoadingScreen - Error during load: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e. Tente novamente.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDAA520)),
            ),
            const SizedBox(height: 20),
            Text(
              'Preparando Combate...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
