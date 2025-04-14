import 'package:flutter/material.dart';
import 'package:midnight_never_end/controllers/user_controller.dart';
import 'package:midnight_never_end/views/pages/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserManager.loadUser(); // Garante que o usuário seja carregado
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rewalker Midnight',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const IntroScreen(), // Sempre vai pra IntroScreen
    );
  }
}
