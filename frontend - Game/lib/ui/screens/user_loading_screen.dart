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

  @override
  void initState() {
    super.initState();
    _loadingFuture = _performLoginAndFetchCombatData();
  }

  Future<Map<String, dynamic>> _performLoginAndFetchCombatData() async {
    try {
      final apiService = context.read<ApiService>();
      final usuario = await apiService.login('rodrigo@gmail.com', '123456789');
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
                // Adiciona rolagem para segurança
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ), // Margem lateral
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Limitar a largura do texto e permitir quebra de linha
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width -
                              32, // Considera o padding
                        ),
                        child: Text(
                          'Erro ao carregar dados: ${snapshot.error}',
                          textAlign: TextAlign.center, // Centraliza o texto
                          style: const TextStyle(fontSize: 16),
                          softWrap: true, // Permite quebra de linha
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _loadingFuture = _performLoginAndFetchCombatData();
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

          return Scaffold(
            appBar: AppBar(title: const Text('Preparar Combate')),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navegação com transição estilo "smoke"
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              CombatScreen(
                                usuario: usuario,
                                combatData: combatData,
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
                              child: Container(
                                color: Colors.black.withOpacity(0.8),
                              ),
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
                },
                child: const Text('Iniciar Combate'),
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: Text('Carregando...')));
      },
    );
  }
}
