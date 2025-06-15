import 'package:flutter/material.dart';

class CombatLoadingWidget extends StatelessWidget {
  const CombatLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
