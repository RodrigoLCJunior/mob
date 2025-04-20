/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Widgets da progressao
 ** Obs...:
 */

import 'package:flutter/material.dart';
import '../../../domain/entities/progressao/progressao_entity.dart';

class ProgressaoWidget extends StatelessWidget {
  final Progressao progressao;

  const ProgressaoWidget({super.key, required this.progressao});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${progressao.id}', style: const TextStyle(fontSize: 18)),
            Text(
              'Moedas Temporárias: ${progressao.totalMoedasTemporarias}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Total de Cliques: ${progressao.totalCliques}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Inimigos Derrotados: ${progressao.totalInimigosDerrotados}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Avatar ID: ${progressao.avatarId}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
