// A classe ApiConfig é responsável por centralizar e gerenciar configurações estáticas utilizadas na
// comunicação com a API do backend. Ela define constantes que determinam o comportamento das requisições,
// como a URL base do servidor, o número máximo de tentativas em caso de falha, o tempo limite para conclusão
// de uma requisição, o intervalo entre tentativas de retry e o tempo limite para verificar a conectividade com
// o servidor (ping). Essas configurações ajudam a padronizar e facilitar a manutenção das chamadas de rede em
// toda a aplicação, garantindo consistência e controle sobre os parâmetros de comunicação.

class ApiConfig {
  static const String baseUrl = 'https://mob-backend-2.onrender.com';
  //static const String baseUrl = 'http://localhost:9090';
  static const int maxRetries = 2;
  static const Duration requestTimeout = Duration(seconds: 60);
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration pingTimeout = Duration(seconds: 5);
}
