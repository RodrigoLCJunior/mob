import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Adicionado para RepositoryProvider
import 'package:midnight_never_end/services/api_service.dart';
import 'package:midnight_never_end/ui/screens/user_loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ApiService(),
      child: MaterialApp(
        title: 'Midnight Never End',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Midnight Never End')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserLoadingScreen(),
                  ),
                );
              },
              child: const Text('Iniciar Combate'),
            ),
          ],
        ),
      ),
    );
  }
}
