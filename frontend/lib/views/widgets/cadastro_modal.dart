// cadastro_modal.dart
// ignore_for_file: no_leading_underscores_for_local_identifiers

/*
 ** Task..: 9 - Tela de Cadastro do Usuario
 ** Data..: 14/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Criar tela de Cadastro para mobile e integração com backend
 ** Obs...: Mostra SnackBar antes de fechar o CadastroModal
*/
import 'package:flutter/material.dart';
import 'package:midnight_never_end/services/user/user_service.dart';

void showCadastroModal(BuildContext context, BuildContext parentContext) {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: false,
    builder:
        (modalContext) => Container(
          height: MediaQuery.of(modalContext).size.height,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 30),
                    onPressed: () {
                      print(
                        "Fechando CadastroModal com modalContext: $modalContext",
                      );
                      Navigator.pop(
                        modalContext,
                      ); // Fecha apenas o CadastroModal
                      // LoginModal já está na pilha
                    },
                  ),
                ),
                const SizedBox(height: 70),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Criar Conta",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Text("Nome:"),
                          TextFormField(
                            controller: _nomeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Digite seu nome",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "O nome não pode estar vazio";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          const Text("Email:"),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Digite seu email",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "O email não pode estar vazio";
                              }
                              final emailRegex = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return "Digite um email válido";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          const Text("Senha:"),
                          TextFormField(
                            controller: _senhaController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Crie uma senha",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "A senha não pode estar vazia";
                              }
                              if (value.length < 8) {
                                return "A senha deve ter pelo menos 8 caracteres";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          const Text("Confirmar Senha:"),
                          TextFormField(
                            controller: _confirmarSenhaController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Repita a senha",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Confirme sua senha";
                              }
                              if (value != _senhaController.text) {
                                return "As senhas não coincidem";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 50),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: const BorderSide(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                minimumSize: const Size(280, 60),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final result = await criarUsuario(
                                    _nomeController.text,
                                    _emailController.text,
                                    _senhaController.text,
                                  );
                                  // Mostra o SnackBar no CadastroModal
                                  ScaffoldMessenger.of(
                                    modalContext,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        result["message"] ??
                                            "Erro desconhecido",
                                      ),
                                      backgroundColor:
                                          result["success"]
                                              ? Colors.green
                                              : Colors.redAccent,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                  // Aguarda o SnackBar desaparecer antes de fechar o modal
                                  if (result["success"]) {
                                    await Future.delayed(
                                      const Duration(seconds: 2),
                                    );
                                    if (modalContext.mounted) {
                                      Navigator.pop(
                                        modalContext,
                                      ); // Fecha o CadastroModal após o SnackBar
                                    }
                                  }
                                }
                              },
                              child: const Text(
                                "Cadastrar",
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}
