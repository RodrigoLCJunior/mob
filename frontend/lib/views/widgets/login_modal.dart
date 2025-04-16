import 'package:flutter/material.dart';
import 'package:midnight_never_end/services/user/user_service.dart';
import 'package:midnight_never_end/views/pages/game_start_screen.dart';
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
  final BuildContext parentContext;

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
      if (!mounted) return;
      setState(() {
        _emailError = null;
        _senhaError = null;
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();

      try {
        final result = await fazerLogin(email, senha);
        if (!mounted) return;
        if (result["success"]) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login realizado com sucesso"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            Navigator.pop(context);
            await Future.delayed(const Duration(milliseconds: 100));
            if (mounted && widget.parentContext.mounted) {
              Navigator.pushReplacement(
                widget.parentContext,
                MaterialPageRoute(
                  builder: (context) => const GameStartScreen(),
                ),
              );
            }
          }
        } else {
          setState(() {
            String errorMessage = result["message"] ?? "Erro ao fazer login";
            if (result["error"] == "email" ||
                errorMessage.toLowerCase().contains("email")) {
              _emailError = errorMessage;
            } else if (result["error"] == "senha" ||
                errorMessage.toLowerCase().contains("senha")) {
              _senhaError = errorMessage;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  backgroundColor: Colors.redAccent,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          });
        }
      } catch (e) {
        print('Erro inesperado no login: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Erro interno. Tente novamente mais tarde."),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtém a largura da tela pra definir a largura dos botões
    final double screenWidth = MediaQuery.of(context).size.width;
    final double inputWidth =
        screenWidth - 40; // 40 é o padding total (20 de cada lado)

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white, // Mantendo o fundo branco
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
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo com uma nuvem estática atrás
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "assets/images/rewalker.png",
                            width: 300,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: inputWidth,
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !_isLoading,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          hintText: "Digite seu email",
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
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: inputWidth,
                      child: TextFormField(
                        controller: _senhaController,
                        obscureText: true,
                        enabled: !_isLoading,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          hintText: "Digite sua senha",
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
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF3B82F6,
                          ), // Azul mais claro
                          foregroundColor:
                              Colors.white, // Texto branco pra contraste
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: Size(inputWidth, 60),
                          elevation: 5,
                        ),
                        onPressed: _isLoading ? null : _login,
                        child:
                            _isLoading
                                ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Logando...",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                                : const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(height: 1, color: Colors.grey[400]),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Ou",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: Container(height: 1, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1E3A8A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: Size(inputWidth, 60),
                          elevation: 5,
                        ),
                        onPressed:
                            _isLoading
                                ? null
                                : () => showCadastroModal(
                                  context,
                                  widget.parentContext,
                                ),
                        child: const Text(
                          "Cadastrar",
                          style: TextStyle(fontSize: 17, color: Colors.black),
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
