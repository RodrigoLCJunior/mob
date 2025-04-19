import 'package:flutter/material.dart';
import '../../../domain/entities/avatar/avatar_entity.dart';

class AvatarWidget extends StatelessWidget {
  final Avatar avatar;

  const AvatarWidget({super.key, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${avatar.id}', style: const TextStyle(fontSize: 18)),
            Text('HP: ${avatar.hp}', style: const TextStyle(fontSize: 16)),
            Text(
              'Dano Base: ${avatar.danoBase}',
              style: const TextStyle(fontSize: 16),
            ),
            if (avatar.progressao != null)
              Text(
                'Total de Cliques: ${avatar.progressao!.totalCliques}',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
