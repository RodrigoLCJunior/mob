import 'package:flutter/material.dart';
import '../../../domain/entities/moeda_permanente/moeda_permanente_entity.dart';

class MoedaPermanenteWidget extends StatelessWidget {
  final MoedaPermanente moeda;

  const MoedaPermanenteWidget({super.key, required this.moeda});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${moeda.id}', style: const TextStyle(fontSize: 18)),
            Text(
              'Quantidade: ${moeda.quantidade}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
