// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

/*
 ** Task..: 6 - Tela de login
 ** Data..: 10/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Criar tela de login para mobile
 ** Obs...:
*/

import 'package:flutter/material.dart';
import 'package:midnight_never_end/services/auth_service.dart';
import 'cadastro_modal.dart';

Future<void> showLoginModal(BuildContext context) {
  final _formKey = GlobalKey<FormState>(); 
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  return showModalBottomSheet( // <-- Retorno adicionado aqui
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: false,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 70),

          // FORMULÁRIO
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Conta",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // CAMPO EMAIL
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
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegex.hasMatch(value)) {
                          return "Digite um email válido";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // CAMPO SENHA
                    const Text("Senha:"),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Digite sua senha",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "A senha não pode estar vazia";
                        }
                        if (value.length < 8) {
                          return "A senha deve ter pelo menos 6 caracteres";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showCadastroModal(context);
                      },
                      child: const Text("Não possui cadastro? Criar Conta"),
                    ),
                    const SizedBox(height: 50),

                    // BOTÃO ENTRAR COM VALIDAÇÃO
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            String email = _emailController.text;
                            String senha = _senhaController.text;
                            login(context, email, senha);
                          }
                        },
                        child: const Text(
                          "Entrar",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Center(child: Text("Ou")),
                    const SizedBox(height: 10),

                    // BOTÃO LOGIN GOOGLE
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          minimumSize: const Size(280, 60),
                        ),
                        onPressed: () {
                          print("Login com Google pressionado");
                        },
                        icon: Image.asset(
                          "assets/logos/logos-google/icon-google-36.png",
                          height: 24,
                        ),
                        label: const Text("Entrar com a conta Google"),
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
  );
}
