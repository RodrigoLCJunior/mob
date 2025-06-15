// Exibe informações do usuário (nome) com ação de toque.

import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {
  final String nome;
  final VoidCallback onTap;

  const UserInfoWidget({super.key, required this.nome, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          nome,
          style: const TextStyle(
            fontFamily: "Cinzel",
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
