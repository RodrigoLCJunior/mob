import 'package:flutter/material.dart';
import 'package:midnight_never_end/controllers/user_controller.dart';
import 'package:midnight_never_end/views/widgets/talent_tile.dart';

class HabilidadesWidget extends StatelessWidget {
  const HabilidadesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coins = UserManager.currentUser?.coins ?? 0;

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
              const Center(
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
              const SizedBox(height: 8),
              const Center(
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

              const SizedBox(height: 40),

              // 💰 Quantidade de moedas
              Row(
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
              ),

              const SizedBox(height: 40),

              // Lista de talentos
              TalentTile(
                icon: Icons.gavel,
                title: "Dano de Ataque",
                level: 5,
                cost: 60,
                onPressed: () {
                  print("Melhorou o dano de Ataque!");
                  // Aqui você pode chamar lógica pra descontar moedas, atualizar o nível etc.
                },
              ),
              TalentTile(
                icon: Icons.bolt,
                title: "Dano de Crítico",
                level: 15,
                cost: 160,
                onPressed: () {
                  print("Melhorou o dano Crítico!");
                  // Aqui você pode chamar lógica pra descontar moedas, atualizar o nível etc.
                },
              ),
              TalentTile(
                icon: Icons.shield,
                title: "Defesa",
                level: 6,
                cost: 70,
                onPressed: () {
                  print("Melhorou a Defesa!");
                  // Aqui você pode chamar lógica pra descontar moedas, atualizar o nível etc.
                },
              ),
              TalentTile(
                icon: Icons.attach_money,
                title: "Ganho de Moeda",
                level: 8,
                cost: 90,
                onPressed: () {
                  print("Melhorou o ganho de Moedas!");
                  // Aqui você pode chamar lógica pra descontar moedas, atualizar o nível etc.
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
