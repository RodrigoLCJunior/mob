class ApiConfig {
  static const String baseUrl =
      "https://mob-backend-ah3e.onrender.com/api/usuarios";
  static const int maxRetries = 2;
  static const Duration requestTimeout = Duration(seconds: 60);
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration pingTimeout = Duration(seconds: 5);
}
