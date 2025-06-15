// A classe ServerException é uma exceção personalizada que implementa a interface Exception,
// usada para representar erros específicos originados no servidor durante a comunicação com a API.
// Ela possui um atributo obrigatório 'message', que armazena uma descrição do erro (ex.: mensagem
// retornada pelo servidor ou um texto explicativo).
// Essa classe permite tratar erros de servidor de forma estruturada, facilitando a captura e o manejo
// de falhas em requisições HTTP, com a possibilidade de exibir a mensagem ao usuário ou usá-la para depuração.

class ServerException implements Exception {
  final String message;
  ServerException({required this.message});

  @override
  String toString() => message;
}
