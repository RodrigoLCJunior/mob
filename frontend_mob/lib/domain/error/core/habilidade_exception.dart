class HabilidadeException implements Exception {
  final String message;

  HabilidadeException(this.message);
}

class ResourcePreloadFailure extends HabilidadeException {
  ResourcePreloadFailure(String message)
    : super('Erro ao pré-carregar recursos: $message');
}

class DataLoadFailure extends HabilidadeException {
  DataLoadFailure(String message) : super('Erro ao carregar dados: $message');
}

class DataSaveFailure extends HabilidadeException {
  DataSaveFailure(String message) : super('Erro ao salvar dados: $message');
}

class AudioFailure extends HabilidadeException {
  AudioFailure(String message) : super('Erro ao reproduzir áudio: $message');
}
