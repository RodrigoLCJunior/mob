import 'package:flutter/material.dart';
import 'package:midnight_never_end/controllers/user_controller.dart';
import 'package:midnight_never_end/models/moeda_permanente/moeda_permanente_entity.dart';
import 'package:midnight_never_end/views/widgets/talent_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class HabilidadesWidget extends StatefulWidget {
  const HabilidadesWidget({super.key});

  @override
  State<HabilidadesWidget> createState() => _HabilidadesWidgetState();
}

class _HabilidadesWidgetState extends State<HabilidadesWidget>
    with SingleTickerProviderStateMixin {
  int coins = 0;
  int initialCoins = 0;
  List<Map<String, dynamic>> talents = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _loadData();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
    _controller.forward();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    if (UserManager.currentUser == null) return;

    int userCoins = UserManager.currentUser!.moedaPermanente?.quantidade ?? 0;
    int savedInitialCoins =
        prefs.getInt('initial_coins_${UserManager.currentUser!.id}') ??
        userCoins;

    setState(() {
      coins = userCoins;
      initialCoins = savedInitialCoins;
      talents = _initializeTalents(prefs);
    });

    await prefs.setInt(
      'initial_coins_${UserManager.currentUser!.id}',
      savedInitialCoins,
    );
  }

  List<Map<String, dynamic>> _initializeTalents(SharedPreferences prefs) {
    return [
      {
        "title": "Dano de Ataque",
        "icon": Icons.gavel,
        "level": prefs.getInt('talent_0_${UserManager.currentUser!.id}') ?? 1,
        "cost": 10,
      },
      {
        "title": "Dano de Crítico",
        "icon": Icons.bolt,
        "level": prefs.getInt('talent_1_${UserManager.currentUser!.id}') ?? 1,
        "cost": 10,
      },
      {
        "title": "Defesa",
        "icon": Icons.shield,
        "level": prefs.getInt('talent_2_${UserManager.currentUser!.id}') ?? 1,
        "cost": 10,
      },
      {
        "title": "Ganho de Moeda",
        "icon": Icons.attach_money,
        "level": prefs.getInt('talent_3_${UserManager.currentUser!.id}') ?? 1,
        "cost": 10,
      },
    ];
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (UserManager.currentUser == null) return;

    UserManager.currentUser = UserManager.currentUser!.copyWith(
      moedaPermanente:
          UserManager.currentUser!.moedaPermanente?.copyWith(
            quantidade: coins,
          ) ??
          MoedaPermanente(id: "default", quantidade: coins),
    );
    await UserManager.setUser(UserManager.currentUser!);
    await prefs.setInt('coins_${UserManager.currentUser!.id}', coins);

    for (int i = 0; i < talents.length; i++) {
      await prefs.setInt(
        'talent_${i}_${UserManager.currentUser!.id}',
        talents[i]["level"],
      );
    }
  }

  Future<void> _playCoinSound() async {
    await _audioPlayer.stop();
    await _audioPlayer.setSource(AssetSource('audios/ka-chin.mp3'));
    await _audioPlayer.resume();
  }

  void _upgradeTalent(int index) {
    if (coins >= talents[index]["cost"]) {
      _playCoinSound();
      setState(() {
        coins -= talents[index]["cost"] as int;
        talents[index]["level"] += 1;
        talents[index]["cost"] = (talents[index]["cost"] * 1.5).round();
      });
      _saveData();
    } else {
      print("Moedas insuficientes!");
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return InsufficientCoinsDialog();
        },
      );
    }
  }

  Future<void> _resetData() async {
    final prefs = await SharedPreferences.getInstance();
    if (UserManager.currentUser == null) return;

    int savedInitialCoins =
        prefs.getInt('initial_coins_${UserManager.currentUser!.id}') ??
        initialCoins;

    setState(() {
      coins = savedInitialCoins;
      talents = _initializeTalents(prefs);
    });

    await prefs.setInt(
      'coins_${UserManager.currentUser!.id}',
      savedInitialCoins,
    );
    for (int i = 0; i < talents.length; i++) {
      await prefs.setInt('talent_${i}_${UserManager.currentUser!.id}', 1);
    }
    UserManager.currentUser = UserManager.currentUser!.copyWith(
      moedaPermanente:
          UserManager.currentUser!.moedaPermanente?.copyWith(
            quantidade: savedInitialCoins,
          ) ??
          MoedaPermanente(id: "default", quantidade: savedInitialCoins),
    );
    await UserManager.setUser(UserManager.currentUser!);
    print("🔄 Reset realizado! Moedas restauradas para $savedInitialCoins.");
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 0.5,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.grey[900]!.withOpacity(0.9),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                border: Border.all(
                  color: Colors.cyanAccent.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  _buildHeader(),
                  _buildCoinDisplay(),
                  ..._buildTalentList(),
                  const SizedBox(height: 20),
                  _buildResetButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Center(
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.5),
                      Colors.cyanAccent.withOpacity(_glowAnimation.value),
                      Colors.white.withOpacity(0.5),
                    ],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
                child: const Text(
                  "TALENTOS",
                  style: TextStyle(
                    fontFamily: "Cinzel",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.cyanAccent,
                        offset: Offset(0, 0),
                      ),
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.white,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Text(
                "Talentos podem fazer com que você\nfique mais forte permanentemente!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Cinzel",
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  shadows: [
                    Shadow(
                      blurRadius: 10.0 * _glowAnimation.value,
                      color: Colors.cyanAccent,
                      offset: const Offset(0, 0),
                    ),
                    Shadow(
                      blurRadius: 5.0 * _glowAnimation.value,
                      color: Colors.white,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCoinDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/permCoin.png',
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 10),
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Text(
              '$coins',
              style: TextStyle(
                fontFamily: "Cinzel",
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0 * _glowAnimation.value,
                    color: Colors.cyanAccent,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    blurRadius: 5.0 * _glowAnimation.value,
                    color: Colors.white,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildTalentList() {
    return talents.asMap().entries.map((entry) {
      final index = entry.key;
      final talent = entry.value;
      return TalentTile(
        icon: talent["icon"],
        title: talent["title"],
        level: talent["level"],
        cost: talent["cost"],
        onPressed: () => _upgradeTalent(index),
        glowAnimation: _glowAnimation,
      );
    }).toList();
  }

  Widget _buildResetButton() {
    return Center(
      child: GestureDetector(
        onTap: _resetData,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.5),
                    blurRadius: 10 * _glowAnimation.value,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                "🔄 RESETAR",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "Cinzel",
                  shadows: [
                    Shadow(
                      blurRadius: 10.0 * _glowAnimation.value,
                      color: Colors.cyanAccent,
                      offset: const Offset(0, 0),
                    ),
                    Shadow(
                      blurRadius: 5.0 * _glowAnimation.value,
                      color: Colors.white,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Novo widget pra o diálogo de moedas insuficientes
class InsufficientCoinsDialog extends StatefulWidget {
  const InsufficientCoinsDialog({super.key});

  @override
  _InsufficientCoinsDialogState createState() =>
      _InsufficientCoinsDialogState();
}

class _InsufficientCoinsDialogState extends State<InsufficientCoinsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.repeat(reverse: true);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        content: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.grey[900]!.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.cyanAccent.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.cyanAccent.withOpacity(_glowAnimation.value),
                          Colors.white.withOpacity(0.5),
                        ],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: const Text(
                      "MOEDAS INSUFICIENTES!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: "Cinzel",
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.cyanAccent,
                            offset: Offset(0, 0),
                          ),
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.white,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(0.5),
                            blurRadius: 10 * _glowAnimation.value,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        "OK",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Cinzel",
                          shadows: [
                            Shadow(
                              blurRadius: 10.0 * _glowAnimation.value,
                              color: Colors.cyanAccent,
                              offset: const Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 5.0 * _glowAnimation.value,
                              color: Colors.white,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
