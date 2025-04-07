/*
 ** Task..: 22 - Tela de Dungeon
 ** Data..: 19/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Criar tela principal do jogo 
 ** Obs...:
*/

// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use, sized_box_for_whitespace, use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:midnight_never_end/controllers/user_controller.dart';
import 'package:midnight_never_end/views/pages/home_screen.dart';
import 'package:midnight_never_end/views/widgets/habilidades_modal.dart';
import 'package:midnight_never_end/views/widgets/opcoes_conta.dart'; // Ajuste o caminho

class GameStartScreen extends StatefulWidget {
  const GameStartScreen({Key? key}) : super(key: key);

  @override
  _GameStartScreenState createState() => _GameStartScreenState();
}

class _GameStartScreenState extends State<GameStartScreen> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  void _nextDungeon() {
    if (selectedIndex < 4) {
      setState(() {
        selectedIndex++;
      });
      _pageController.animateToPage(
        selectedIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousDungeon() {
    if (selectedIndex > 0) {
      setState(() {
        selectedIndex--;
      });
      _pageController.animateToPage(
        selectedIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo da tela
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Conteúdo da tela
          Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      child: PopupMenuButton<int>(
                        offset: const Offset(0, 60),
                        color: Colors.grey.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 0:
                              print('Abrir configurações');
                              break;
                            case 1:
                              showSignOutConfirmation(context, () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              });
                              break;
                          }
                        },
                        itemBuilder:
                            (context) => [
                              const PopupMenuItem<int>(
                                value: 0,
                                child: Row(
                                  children: [
                                    Icon(Icons.settings, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      'Configurações',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<int>(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(Icons.logout, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      'Sair',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                "assets/images/pfp/default.png",
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 110,
                                minWidth: 110,
                              ),
                              child: Text(
                                UserManager.currentUser?.nome ?? "Usuario",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Kirsty",
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
                    ),
                    // Moedas com imagem
                    Row(
                      children: [
                        Text(
                          '${UserManager.currentUser?.moedaPermanente?.quantidade ?? 0} ',
                          style: const TextStyle(
                            fontFamily: "Kirsty",
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Color.fromARGB(255, 40, 40, 40),
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Image.asset(
                          'assets/icons/permCoin.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Carrossel de dungeons com botões de navegação
              Flexible(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centraliza verticalmente
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_left,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed:
                              selectedIndex > 0 ? _previousDungeon : null,
                          padding: const EdgeInsets.all(8),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 330,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: 5,
                            onPageChanged: (index) {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/images/mini_dungeons/dungeon_${index + 1}.png",
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Text(
                                        "Imagem não encontrada",
                                        style: TextStyle(color: Colors.white),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "DUNGEON ${index + 1}",
                                    style: const TextStyle(
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: "Kirsty",
                                      shadows: [
                                        Shadow(
                                          blurRadius: 5.0,
                                          color: Color.fromARGB(
                                            255,
                                            40,
                                            40,
                                            40,
                                          ),
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_right,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed: selectedIndex < 4 ? _nextDungeon : null,
                          padding: const EdgeInsets.all(8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Botão Jogar
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                ), // Reduzido para evitar overflow
                child: ElevatedButton(
                  onPressed: () {
                    print("Entrando na Dungeon ${selectedIndex + 1}");
                    // Aqui você pode adicionar a lógica para entrar na dungeon
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 80),
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Jogar",
                    style: TextStyle(
                      fontFamily: "Kirsty",
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
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
              ),

              // Barra inferior com as abas
              SizedBox(
                height: 80,
                child: BottomNavigationBar(
                  currentIndex: 1,
                  onTap: (index) {
                    if (index == 2) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const HabilidadesWidget(),
                      ).whenComplete(() {
                        setState(
                          () {},
                        ); // Atualiza moedas ao fechar habilidades
                      });
                    } else {
                      print("Aba selecionada: $index");
                    }
                  },
                  iconSize: 40,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.lock),
                      label: 'Coming Soon',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Principal',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.star),
                      label: 'Habilidades',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
