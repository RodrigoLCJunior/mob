import 'package:flutter/material.dart';
import 'package:midnight_never_end/UI/pages/home_screen.dart';
import 'package:midnight_never_end/domain/managers/usuario_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante inicialização correta
  await UserManager.loadUser();              // Carrega usuário salvo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Midnight Never End',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}