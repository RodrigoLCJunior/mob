/*
 ** Task..: 8 - Criação da Tela inicial do Jogo
 ** Data..: 06/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Criar a tela inicial do jogo e mostrar nome do jogado ao fazer login
 ** Obs...:
*/

import 'package:flutter/material.dart';
import 'package:midnight_never_end/domain/managers/usuario_manager.dart';
import 'package:midnight_never_end/UI/widgets/login_modal.dart';
import 'package:midnight_never_end/UI/widgets/opcoes_conta.dart'; // Importando o arquivo de opções de conta
import 'game_start_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "CONTA";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    setState(() {
      userName = UserManager.currentUser?.name ?? "CONTA";
    });
  }

  void _updateUser() {
    setState(() {
      userName = UserManager.currentUser?.name ?? "CONTA";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "MIDNIGHT\nNEVER END\n",
                  style: TextStyle(
                    fontFamily: "Balmy",
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Color.fromARGB(255, 100, 100, 100),
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 150),
                ElevatedButton(
                  onPressed: () {
                    if (UserManager.currentUser != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GameStartScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Você precisa estar logado para iniciar o jogo!"),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(210, 80),
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "INICIAR",
                    style: TextStyle(
                      fontFamily: "Balmy",
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Color.fromARGB(255, 40, 40, 40),
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (UserManager.currentUser == null) {
                      showLoginModal(context).then((_) {
                        _updateUser();
                      });
                    } else {
                      showAccountOptions(context, userName, _updateUser);  // Passa o _updateUser
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(210, 80),
                    maximumSize: const Size(210, 80),
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    UserManager.currentUser == null ? "CONTA" : "${UserManager.currentUser!.name}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,                     
                    style: const TextStyle(
                      fontFamily: "Balmy",
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Color.fromARGB(255, 40, 40, 40),
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
