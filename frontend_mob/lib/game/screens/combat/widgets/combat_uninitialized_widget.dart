import 'package:flutter/material.dart';

class CombatUninitializedWidget extends StatelessWidget {
  const CombatUninitializedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Combate não inicializado'));
  }
}
