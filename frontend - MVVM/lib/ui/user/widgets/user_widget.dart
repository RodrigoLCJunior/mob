import 'package:flutter/material.dart';
import '../../../domain/entities/user/user_entity.dart';

class UserWidget extends StatelessWidget {
  final User user;

  const UserWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${user.nome}', style: const TextStyle(fontSize: 18)),
            Text('Email: ${user.email}', style: const TextStyle(fontSize: 16)),
            if (user.avatar != null)
              Text(
                'HP do Avatar: ${user.avatar!.hp}',
                style: const TextStyle(fontSize: 16),
              ),
            if (user.moedaPermanente != null)
              Text(
                'Moedas Permanentes: ${user.moedaPermanente!.quantidade}',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
