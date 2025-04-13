import 'package:flutter/material.dart';
import 'package:midnight_never_end/services/user/user_service.dart';
import 'package:midnight_never_end/views/pages/game_start_screen.dart';

Future<void> showCadastroModal(
  BuildContext context,
  BuildContext parentContext,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CadastroModal(parentContext: parentContext),
  );
}

class CadastroModal extends StatefulWidget {
  final BuildContext parentContext;

  const CadastroModal({super.key, required this.parentContext});

  @override
  _CadastroModalState createState() => _CadastroModalState();
}

class _CadastroModalState extends State<CadastroModal> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();
  String? _nomeError;
  String? _emailError;
  String? _senhaError;
  String? _confirmaSenhaError;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      if (!mounted) return;
      setState(() {
        _nomeError = null;
        _emailError = null;
        _senhaError = null;
        _confirmaSenhaError = null;
        _isLoading = true;
      });

      final nome = _nomeController.text.trim();
      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();

      try {
        final cadastroResult = await criarUsuario(nome, email, senha);
        if (!mounted) return;

        if (cadastroResult["success"]) {
          // Mostra a mensagem de sucesso por 2 segundos
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Cadastro feito com sucesso"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Faz o login automático
          final loginResult = await fazerLogin(email, senha);
          if (!mounted) return;

          if (loginResult["success"]) {
            // Aguarda a SnackBar desaparecer antes de fechar os modais
            await Future.delayed(const Duration(seconds: 2));
            if (mounted) {
              Navigator.pop(context); // Fecha o CadastroModal
              Navigator.pop(widget.parentContext); // Fecha o LoginModal
              await Future.delayed(const Duration(milliseconds: 300));
              if (mounted && widget.parentContext.mounted) {
                Navigator.of(widget.parentContext).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const GameStartScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              }
            }
          } else {
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    loginResult["message"] ??
                        "Erro ao fazer login após cadastro",
                  ),
                  backgroundColor: Colors.redAccent,
                  duration: const Duration(seconds: 3),
                ),
              );
            });
          }
        } else {
          setState(() {
            if (cadastroResult["message"]?.toLowerCase().contains("email") ??
                false) {
              _emailError = cadastroResult["message"]; // Ex.: "Email já usado"
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    cadastroResult["message"] ?? "Erro ao cadastrar",
                  ),
                  backgroundColor: Colors.redAccent,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          });
        }
      } catch (e) {
        print('Erro inesperado no cadastro ou login: $e');
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
    // Obtém a largura da tela pra definir a largura dos botões e campos
    final double inputWidth =
        MediaQuery.of(context).size.width -
        40; // 40 é o padding total (20 de cada lado)

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
                          // Nuvem estática atrás da logo
                          Image.asset(
                            "assets/images/dark_cloud.png",
                            width: 400, // Mesmo tamanho do LoginModal
                            height: 240,
                            fit: BoxFit.contain,
                          ),
                          Image.asset(
                            "assets/images/logo_image.png",
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
                        controller: _nomeController,
                        enabled: !_isLoading,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          hintText: "Digite seu nome",
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "O nome não pode estar vazio";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    SizedBox(
                      width: inputWidth,
                      child: TextFormField(
                        controller: _confirmaSenhaController,
                        obscureText: true,
                        enabled: !_isLoading,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          hintText: "Confirme sua senha",
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "A confirmação de senha não pode estar vazia";
                          }
                          if (value != _senhaController.text) {
                            return "As senhas não coincidem";
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
                          ), // Mesmo azul do Login
                          foregroundColor: Colors.white, // Texto branco
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              5,
                            ), // Bordas quadradas
                          ),
                          minimumSize: Size(
                            inputWidth,
                            60,
                          ), // Mesma largura dos inputs
                          elevation: 5,
                        ),
                        onPressed: _isLoading ? null : _cadastrar,
                        child:
                            _isLoading
                                ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white, // Indicador branco
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Cadastrando...",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                                : const Text(
                                  "Cadastrar",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
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
    );
  }
}
