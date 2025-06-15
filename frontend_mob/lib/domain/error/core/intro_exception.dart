// Este arquivo define as exceções específicas para a tela de introdução (IntroScreen), seguindo o padrão do domínio do projeto.
// As exceções são usadas pelo IntroViewModel para tratar erros de forma específica, como falhas ao carregar o usuário, pingar o backend, reproduzir áudio, carregar imagens ou navegar.
// Inspirado no padrão do LoginViewModel (order_manager/domain/error/login/login_exception.dart).

// Nota: Conforme solicitado, este arquivo é separado do IntroViewModel e colocado em domain/error/intro.
// Não há referências a mapas ou bancos de dados não relacionais, respeitando as restrições do projeto.

/// Exceção base para erros relacionados à tela de introdução.
abstract class IntroException implements Exception {
  final String message;

  const IntroException(this.message);

  @override
  String toString() => 'IntroException: $message';
}

/// Exceção lançada quando há falha ao carregar o usuário do banco de dados (SQLite).
class UserLoadFailure extends IntroException {
  const UserLoadFailure([String message = 'Falha ao carregar usuário'])
    : super(message);
}

/// Exceção lançada quando há falha ao pingar o backend.
class PingFailure extends IntroException {
  const PingFailure([String message = 'Falha ao conectar com o servidor'])
    : super(message);
}

/// Exceção lançada quando há falha ao reproduzir áudio (música ou sons).
class AudioFailure extends IntroException {
  const AudioFailure([String message = 'Falha ao reproduzir áudio'])
    : super(message);
}

/// Exceção lançada quando há falha ao carregar tamanhos de imagens.
class ImageLoadFailure extends IntroException {
  const ImageLoadFailure([String message = 'Falha ao carregar imagens'])
    : super(message);
}

/// Exceção lançada quando há falha na navegação (ex.: para GameStartScreen).
class NavigationFailure extends IntroException {
  const NavigationFailure([String message = 'Falha na navegação'])
    : super(message);
}
