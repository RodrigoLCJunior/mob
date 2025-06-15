// Define exceções específicas para a tela inicial (GameStartScreen), seguindo o padrão do domínio do projeto.
// As exceções são usadas pelo GameStartViewModel para tratar erros de forma específica, como falhas ao reproduzir áudio ou carregar imagens.

// Nota: Conforme solicitado, este arquivo é separado do GameStartViewModel e colocado em domain/error/core.
// Não há referências a mapas ou bancos de dados não relacionais, respeitando as restrições do projeto.

/// Exceção base para erros relacionados à tela inicial.
abstract class GameStartException implements Exception {
  final String message;

  const GameStartException(this.message);

  @override
  String toString() => 'GameStartException: $message';
}

/// Exceção genérica para erros da tela inicial.
class GameStartFailure extends GameStartException {
  const GameStartFailure([String message = 'Erro na tela inicial'])
    : super(message);
}

/// Exceção lançada quando há falha ao reproduzir áudio (música ou sons).
class GameStartAudioFailure extends GameStartException {
  const GameStartAudioFailure([String message = 'Falha ao reproduzir áudio'])
    : super(message);
}

/// Exceção lançada quando há falha ao carregar imagens.
class GameStartImageLoadFailure extends GameStartException {
  const GameStartImageLoadFailure([
    String message = 'Falha ao carregar imagens',
  ]) : super(message);
}

/// Exceção lançada quando há falha ao reproduzir áudio (música ou sons).
class AudioFailure extends GameStartException {
  const AudioFailure([String message = 'Falha ao reproduzir áudio'])
    : super(message);
}
