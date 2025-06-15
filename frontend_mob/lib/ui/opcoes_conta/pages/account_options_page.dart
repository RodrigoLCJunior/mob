import 'package:flutter/material.dart';
import 'package:midnight_never_end/ui/game_start/view_models/game_start_view_model.dart';
import 'package:midnight_never_end/ui/intro/pages/intro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountOptionsPage extends StatelessWidget {
  final String userName;
  final GameStartViewModel viewModel;

  const AccountOptionsPage({
    super.key,
    required this.userName,
    required this.viewModel,
  });

  Future<void> _logout(BuildContext context) async {
    try {
      await viewModel.stopMusic(); // Para a música antes do logout
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao fazer logout. Tente novamente.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Opções da Conta',
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.cyanAccent),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bem-vindo, $userName',
                style: const TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
