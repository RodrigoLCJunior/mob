import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/data/repositories/game/game_repository.dart';
import 'package:midnight_never_end/domain/entities/combat/combat_initial_data.dart';
import 'package:midnight_never_end/domain/entities/user/user_entity.dart';
import 'package:midnight_never_end/game/screens/combat_screen.dart';

class UserLoadingScreen extends StatefulWidget {
  final Usuario usuario;
  final GameRepository gameRepository;

  const UserLoadingScreen({
    super.key,
    required this.usuario,
    required this.gameRepository,
  });

  @override
  State<UserLoadingScreen> createState() => _UserLoadingScreenState();
}

class _UserLoadingScreenState extends State<UserLoadingScreen> {
  late Future<Map<String, dynamic>> _loadingFuture;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _loadingFuture = _fetchCombatData();
  }

  Future<Map<String, dynamic>> _fetchCombatData() async {
    try {
      final gameRepository = widget.gameRepository;
      final combatData = await gameRepository.startCombat(widget.usuario.id);
      print(
        'UserLoadingScreen - Combat data fetched: avatarHp=${combatData.avatar.hp}, enemyHp=${combatData.enemy.hp}, enemyName=${combatData.enemy.nome}',
      );
      return {'usuario': widget.usuario, 'combatData': combatData};
    } catch (e) {
      print('UserLoadingScreen - Error: $e');
      throw e;
    }
  }

  void _navigateToCombatScreen(Usuario usuario, CombatInitialData combatData) {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    print('UserLoadingScreen - Iniciando navegação para CombatScreen');
    Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    CombatScreen(usuario: usuario, combatData: combatData),
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
        )
        .then((value) {
          print('UserLoadingScreen - Retornou da CombatScreen');
          _hasNavigated = false;
        })
        .catchError((error) {
          print(
            'UserLoadingScreen - Erro na navegação para CombatScreen: $error',
          );
          _hasNavigated = false;
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 32,
                        ),
                        child: Text(
                          'Erro ao carregar dados: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _loadingFuture = _fetchCombatData();
                            _hasNavigated = false;
                          });
                        },
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          final usuario = snapshot.data!['usuario'] as Usuario;
          final combatData = snapshot.data!['combatData'] as CombatInitialData;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigateToCombatScreen(usuario, combatData);
          });

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return const Scaffold(body: Center(child: Text('Carregando...')));
      },
    );
  }
}
