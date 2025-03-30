/*
 ** Task..: 27 - Possibilidade de troca de usuario
 ** Data..: 26/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Oferecer a opção do usuario trocar de conta ou deslogar
 ** Obs...:
*/

import 'package:flutter/material.dart';
import 'package:midnight_never_end/domain/managers/usuario_manager.dart';
import 'package:midnight_never_end/UI/widgets/login_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _logout(VoidCallback updateState) async {
  // Remover dados do usuário de SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');

  UserManager.currentUser = null;
  updateState();
}

void showSignOutConfirmation(BuildContext context, VoidCallback updateState) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Confirmação",
          textAlign: TextAlign.center, // Centraliza o título
        ),
        content: Text(
          "Tem certeza que deseja sair?",
          textAlign: TextAlign.center, // Centraliza o conteúdo
          style: TextStyle(
            fontSize: 17, // Aumenta o tamanho da fonte
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza os botões
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Borda arredondada
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Padding
                  minimumSize: const Size(120, 50),
                ),
                child: const Text(
                  "Cancelar",
                    style: TextStyle(
                      fontSize: 20, // Aumenta o tamanho da fonte
                    ),
                  ),
              ),
              const SizedBox(width: 10), // Espaçamento entre os botões
              TextButton(
                onPressed: () {
                  _logout(updateState);  // Passa a função updateState
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Borda arredondada
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Padding
                  minimumSize: const Size(90, 50),
                ),
                child: const Text(
                  "Sair",
                  style: TextStyle(
                    fontSize: 20, // Aumenta o tamanho da fonte
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}





void showAccountOptions(BuildContext context, String userName, VoidCallback updateState) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        padding: const EdgeInsets.all(15),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.switch_account),
              title: const Text("Trocar de conta"),
              onTap: () {
                Navigator.pop(context); // Fecha o menu
                showLoginModal(context).then((_) {
                  updateState();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sair"),
              onTap: () {
                showSignOutConfirmation(context, updateState); // Passa a função updateState
              },
            ),
          ],
        ),
      );
    },
  );
}
