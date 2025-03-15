import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

void showCadastroModal(BuildContext context) {
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
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // CAMPO NOME
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

                    // CAMPO CONFIRMAR SENHA
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

                    // BOTÃO CADASTRAR
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
                        onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            String nome = _nomeController.text;
                            String email = _emailController.text;
                            String senha = _senhaController.text;
                            cadastrarUsuario(context, nome, email, senha);
                          }
                        },
                        child: const Text(
                          "Cadastrar",
                          style: TextStyle(
                            fontSize: 17,
                          ),
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
  );
}
