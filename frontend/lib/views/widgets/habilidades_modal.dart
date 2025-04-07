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

class _HabilidadesWidgetState extends State<HabilidadesWidget> {
  int coins = 0;
  int initialCoins = 0;
  List<Map<String, dynamic>> talents = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadData();
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

    // Atualiza as moedas permanentes no UserManager
    UserManager.currentUser = UserManager.currentUser!.copyWith(
      moedaPermanente:
          UserManager.currentUser!.moedaPermanente?.copyWith(
            quantidade: coins,
          ) ??
          MoedaPermanente(id: "default", quantidade: coins),
    );
    await UserManager.setUser(
      UserManager.currentUser!,
    ); // Salva no SharedPreferences
    await prefs.setInt('coins_${UserManager.currentUser!.id}', coins);

    // Salva os níveis dos talentos
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
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFEEEEEE),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              _buildHeader(),
              _buildCoinDisplay(),
              ..._buildTalentList(),
              _buildResetButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: const [
        Center(
          child: Text(
            "\nTalentos",
            style: TextStyle(
              fontFamily: "Kirsty",
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: Text(
            "Talentos podem fazer com que você\nfique mais forte permanentemente!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Kirsty",
              fontSize: 20,
              color: Colors.black54,
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
        Text(
          '$coins',
          style: const TextStyle(
            fontFamily: "Kirsty",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 10),
        Image.asset(
          'assets/icons/permCoin.png',
          width: 40,
          height: 40,
          fit: BoxFit.contain,
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
      );
    }).toList();
  }

  Widget _buildResetButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _resetData,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
        ),
        child: const Text(
          "🔄 Resetar ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
