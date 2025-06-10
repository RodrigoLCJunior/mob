// A classe abstrata Failure serve como uma classe base para representar diferentes tipos de falhas ou erros na aplicação,
// funcionando como um contrato genérico para subclasses específicas.
// Ela não contém implementação, permitindo que subclasses definam detalhes próprios para cada tipo de falha.

// A classe ServerFailure é uma implementação concreta da classe Failure, usada para representar falhas específicas
// originadas no servidor durante interações com a API.
// Ela possui um atributo 'message' que armazena uma descrição do erro (ex.: mensagem retornada pelo servidor ou um texto
// explicativo).
// Essa estrutura facilita o tratamento hierárquico de erros, permitindo que a aplicação identifique e gerencie falhas de
// servidor de forma distinta, com a mensagem fornecendo contexto para depuração ou exibição ao usuário.

abstract class Failure {}

class ServerFailure extends Failure {
  final String message;
  ServerFailure(this.message);
}
