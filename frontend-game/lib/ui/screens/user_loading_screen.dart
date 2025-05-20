import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/models/usuario.dart';
import 'package:midnight_never_end/models/combat_initial_data.dart';
import 'package:midnight_never_end/services/api_service.dart';
import 'package:midnight_never_end/ui/screens/combat_screen.dart';

class UserLoadingScreen extends StatefulWidget {
  const UserLoadingScreen({super.key});

  @override
  State<UserLoadingScreen> createState() => _UserLoadingScreenState();
}

class _UserLoadingScreenState extends State<UserLoadingScreen> {
  late Future<Map<String, dynamic>> _loadingFuture;
  bool _hasNavigated = false; // Para evitar navegação múltipla

  @override
  void initState() {
    super.initState();
    _loadingFuture = _performLoginAndFetchCombatData();
  }

  Future<Map<String, dynamic>> _performLoginAndFetchCombatData() async {
    try {
      final apiService = context.read<ApiService>();
      final usuario = await apiService.login('filipe@gmail.com', 'lipe12345');
      print('UserLoadingScreen - Login successful, usuario ID: ${usuario.id}');
      final combatData = await apiService.startCombat(usuario.id);
      print(
        'UserLoadingScreen - Combat data fetched: avatarHp=${combatData.avatar.hp}, enemyHp=${combatData.enemy.hp}, enemyName=${combatData.enemy.nome}',
      );
      return {'usuario': usuario, 'combatData': combatData};
    } catch (e) {
      print('UserLoadingScreen - Error: $e');
      throw e;
    }
  }

  void _navigateToCombatScreen(Usuario usuario, CombatInitialData combatData) {
    if (_hasNavigated || !mounted)
      return; // Evitar navegação múltipla ou após descarte
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
          _hasNavigated = false; // Permitir nova navegação se necessário
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
                            _loadingFuture = _performLoginAndFetchCombatData();
                            _hasNavigated = false; // Resetar navegação
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

          // Agendar a navegação após o build
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
