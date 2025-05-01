import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:midnight_never_end/controllers/user_controller.dart';
import 'package:midnight_never_end/models/moeda_permanente/moeda_permanente_entity.dart';
import 'package:midnight_never_end/views/widgets/talent_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';

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
  final logger = Logger();
  bool _resourcesPreloaded =
      false; // Flag pra evitar múltiplos pré-carregamentos

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

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_resourcesPreloaded) {
      _preloadResources();
      _resourcesPreloaded = true;
    }
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
    if (kDebugMode) logger.d("HabilidadesWidget descartado");
  }

  Future<void> _preloadResources() async {
    try {
      await precacheImage(AssetImage("assets/icons/permCoin.png"), context);
      await _audioPlayer.setVolume(0.5);
      await _audioPlayer.setSource(AssetSource('audios/ka-chin.mp3'));
      if (kDebugMode) logger.d("Recursos pré-carregados com sucesso");
    } catch (e, stackTrace) {
      if (kDebugMode)
        logger.e("Erro ao pré-carregar recursos: $e\n$stackTrace");
    }
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
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audios/ka-chin.mp3'));
      if (kDebugMode) logger.d("Som de moeda tocado");
    } catch (e, stackTrace) {
      if (kDebugMode) logger.e("Erro ao tocar som de moeda: $e\n$stackTrace");
    }
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
      if (kDebugMode) logger.d("Moedas insuficientes!");
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return const InsufficientCoinsDialog();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 0.5,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: ListView.builder(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              itemCount:
                  talents.length +
                  2, // Header, moedas e talentos (sem botão de reset)
              itemBuilder: (context, index) {
                if (index == 0) return _buildHeader();
                if (index == 1) return _buildCoinDisplay();
                final talentIndex = index - 2;
                final talent = talents[talentIndex];
                return TalentTile(
                  icon: talent["icon"],
                  title: talent["title"],
                  level: talent["level"],
                  cost: talent["cost"],
                  onPressed: () => _upgradeTalent(talentIndex),
                  glowAnimation: null,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Center(
          child: Text(
            "TALENTOS",
            style: TextStyle(
              fontFamily: "Cinzel",
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent, // Texto em azul
            ),
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: Text(
            "Talentos podem fazer com que você\nfique mais forte permanentemente!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Cinzel",
              fontSize: 16,
              color: Colors.cyanAccent, // Texto em azul
            ),
          ),
        ),
        SizedBox(height: 40),
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
        Text(
          '$coins',
          style: const TextStyle(
            fontFamily: "Cinzel",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent, // Texto em azul
          ),
        ),
      ],
    );
  }
}

class InsufficientCoinsDialog extends StatefulWidget {
  const InsufficientCoinsDialog({super.key});

  @override
  _InsufficientCoinsDialogState createState() =>
      _InsufficientCoinsDialogState();
}

class _InsufficientCoinsDialogState extends State<InsufficientCoinsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
    if (kDebugMode) logger.d("InsufficientCoinsDialog descartado");
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
            color: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.cyanAccent.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "MOEDAS INSUFICIENTES!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent, // Texto em azul
                  fontFamily: "Cinzel",
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Texto em preto pra contrastar
                      fontFamily: "Cinzel",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
