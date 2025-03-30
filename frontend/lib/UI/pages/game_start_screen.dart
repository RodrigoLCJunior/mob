/*
 ** Task..: 22 - Tela de Dungeon
 ** Data..: 19/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Criar tela principal do jogo 
 ** Obs...:
*/

import 'package:flutter/material.dart';
import 'package:midnight_never_end/domain/managers/usuario_manager.dart';

class GameStartScreen extends StatefulWidget {
  const GameStartScreen({Key? key}) : super(key: key);

  @override
  _GameStartScreenState createState() => _GameStartScreenState();
}

class _GameStartScreenState extends State<GameStartScreen> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  void _nextDungeon() {
    if (selectedIndex < 4) { // Supondo que tenha 5 dungeons (0 a 4)
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
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
                            constraints: BoxConstraints(maxWidth: 110), // Define o limite máximo de largura
                            child: Text(
                              UserManager.currentUser?.name ?? "Usuario",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 35,
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
                          ),
                        ],
                      ),
                    ),
                    // Moedas com imagem
                    Row(
                      children: [
                        Text(
                          '${UserManager.currentUser?.coins}', // QTD MOEDAS
                          style: const TextStyle(
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
                          'assets/icons/permCoin.png', // IMAGEM MOEDA
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
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Botão de voltar
                      IconButton(
                        icon: const Icon(Icons.arrow_left, size: 40, color: Colors.white),
                        onPressed: _previousDungeon,
                        padding: const EdgeInsets.all(8),
                      ),

                      // Página das dungeons
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7, // Garante um tamanho responsivo
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/mini_dungeons/dungeon_${index + 1}.png",
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "DUNGEON ${index + 1}",  // Use o 'index' diretamente aqui
                                  style: const TextStyle(
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: "Balmy",
                                    shadows: [
                                      Shadow(
                                        blurRadius: 5.0,
                                        color: Color.fromARGB(255, 40, 40, 40),
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

                      // Botão de avançar
                      IconButton(
                        icon: const Icon(Icons.arrow_right, size: 40, color: Colors.white),
                        onPressed: _nextDungeon,
                        padding: const EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ),
              ),

              // Botão Jogar
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: ElevatedButton(
                  onPressed: () {
                    print("Entrando na Dungeon ${selectedIndex + 1}");
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 80),
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Jogar",
                    style: TextStyle(
                      fontFamily: "Balmy",
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
              Container(
                height: 80, // Ajuste a altura desejada
                child: BottomNavigationBar(
                  currentIndex: 1,
                  onTap: (index) {
                    print("Aba selecionada: $index");
                  },
                  iconSize: 40, // Aumenta o tamanho dos ícones
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Configurações',
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
