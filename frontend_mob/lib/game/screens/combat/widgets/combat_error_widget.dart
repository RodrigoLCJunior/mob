import 'package:flutter/material.dart';

class CombatErrorWidget extends StatelessWidget {
  final String error;

  const CombatErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Erro: $error'));
  }
}
