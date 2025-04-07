// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

/*
 ** Task..: 6 - Tela de login
 ** Data..: 10/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Criar tela de login para mobile
 ** Obs...: Mantém LoginModal na pilha ao abrir CadastroModal
*/

import 'package:flutter/material.dart';
import 'package:midnight_never_end/services/user/user_service.dart';
import 'cadastro_modal.dart';

Future<void> showLoginModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: false,
    builder: (context) => LoginModal(parentContext: context),
  );
}

class LoginModal extends StatefulWidget {
  final BuildContext parentContext; // Contexto da tela principal

  const LoginModal({super.key, required this.parentContext});

  @override
  _LoginModalState createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  String? _emailError;
  String? _senhaError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _emailError = null;
        _senhaError = null;
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();

      try {
        final result = await fazerLogin(email, senha);
        if (result["success"]) {
          Navigator.pop(context);
        } else {
          setState(() {
            if (result["error"] == "email") {
              _emailError = result["message"];
            } else if (result["error"] == "senha") {
              _senhaError = result["message"];
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result["message"] ?? "Erro ao fazer login"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          });
        }
      } catch (e) {
        print('Erro inesperado: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro interno. Tente novamente mais tarde."),
            backgroundColor: Colors.redAccent,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30),
              onPressed: _isLoading ? null : () => Navigator.pop(context),
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
                        "Conta",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Email:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        hintText: "Digite seu email",
                        errorText: _emailError,
                        filled: true,
                        fillColor: Colors.white,
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
                    const SizedBox(height: 20),
                    const Text(
                      "Senha:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        hintText: "Digite sua senha",
                        errorText: _senhaError,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "A senha não pode estar vazia";
                        }
                        if (value.length < 6) {
                          return "A senha deve ter pelo menos 6 caracteres";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed:
                            _isLoading
                                ? null
                                : () {
                                  // Não fecha o LoginModal, apenas abre o CadastroModal
                                  showCadastroModal(
                                    context,
                                    widget.parentContext,
                                  );
                                },
                        child: const Text(
                          "Não possui cadastro? Criar Conta",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          minimumSize: const Size(280, 60),
                          elevation: 5,
                        ),
                        onPressed: _isLoading ? null : _login,
                        child:
                            _isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  "Entrar",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text("Ou", style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          minimumSize: const Size(280, 60),
                          elevation: 5,
                        ),
                        onPressed:
                            _isLoading
                                ? null
                                : () {
                                  print("Login com Google pressionado");
                                },
                        icon: Image.asset(
                          "assets/logos/logos-google/icon-google-36.png",
                          height: 24,
                        ),
                        label: const Text(
                          "Entrar com a conta Google",
                          style: TextStyle(fontSize: 16, color: Colors.black),
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
    );
  }
}
