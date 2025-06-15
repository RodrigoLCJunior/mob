import 'package:flutter/material.dart';

class UserLoadingUI extends StatelessWidget {
  final String? error;
  final VoidCallback? onRetry;

  const UserLoadingUI.loading({super.key}) : error = null, onRetry = null;

  const UserLoadingUI.error({
    super.key,
    required this.error,
    required this.onRetry,
  });

  const UserLoadingUI.defaultState({super.key}) : error = null, onRetry = null;

  @override
  Widget build(BuildContext context) {
    if (error != null && onRetry != null) {
      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 32,
                    ),
                    child: Text(
                      'Erro ao carregar dados: $error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: onRetry,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (error == null && onRetry == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return const Scaffold(body: Center(child: Text('Carregando...')));
  }
}
