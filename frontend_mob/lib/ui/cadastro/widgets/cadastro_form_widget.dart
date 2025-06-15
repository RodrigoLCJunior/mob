import 'package:flutter/material.dart';

class CadastroFormWidget extends StatelessWidget {
  final double inputWidth;
  final String nome;
  final String email;
  final String senha;
  final String confirmaSenha;
  final String? nomeError;
  final String? emailError;
  final String? senhaError;
  final String? confirmaSenhaError;
  final bool isLoading;
  final ValueChanged<String> onNomeChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onSenhaChanged;
  final ValueChanged<String> onConfirmaSenhaChanged;

  const CadastroFormWidget({
    super.key,
    required this.inputWidth,
    required this.nome,
    required this.email,
    required this.senha,
    required this.confirmaSenha,
    required this.onNomeChanged,
    required this.onEmailChanged,
    required this.onSenhaChanged,
    required this.onConfirmaSenhaChanged,
    this.nomeError,
    this.emailError,
    this.senhaError,
    this.confirmaSenhaError,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: inputWidth,
            child: TextFormField(
              initialValue: nome,
              onChanged: onNomeChanged,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color: Colors.grey),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                hintText: "Digite seu nome",
                filled: true,
                fillColor: Colors.white,
                errorText: nomeError,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: inputWidth,
            child: TextFormField(
              initialValue: email,
              onChanged: onEmailChanged,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: Colors.grey),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                hintText: "Digite seu email",
                filled: true,
                fillColor: Colors.white,
                errorText: emailError,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: inputWidth,
            child: TextFormField(
              initialValue: senha,
              onChanged: onSenhaChanged,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                hintText: "Digite sua senha",
                filled: true,
                fillColor: Colors.white,
                errorText: senhaError,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: inputWidth,
            child: TextFormField(
              initialValue: confirmaSenha,
              onChanged: onConfirmaSenhaChanged,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                hintText: "Confirme sua senha",
                filled: true,
                fillColor: Colors.white,
                errorText: confirmaSenhaError,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
