import 'package:shared_preferences/shared_preferences.dart';
import '../core/service/audio_service.dart';
import '../utils/logger.dart';

class AppConfig {
  // Configurações globais
  static const String appName = 'Midnight Never End';
  static const String appVersion = '1.0.0';
  static const bool isDebugMode = true;

  // Instância de SharedPreferences
  static late SharedPreferences _sharedPreferences;

  // Instância de AudioService
  static late AudioService _audioService;

  // Método para inicializar as configurações do app
  static Future<void> initialize() async {
    // Inicializa o SharedPreferences
    _sharedPreferences = await SharedPreferences.getInstance();

    // Inicializa o logger
    Logger.init(isDebugMode);

    // Inicializa o AudioService
    _audioService = AudioService();
    await _audioService.initialize();
  }

  // Getter para acessar o SharedPreferences
  static SharedPreferences get sharedPreferences => _sharedPreferences;

  // Getter para acessar o AudioService
  static AudioService get audioService => _audioService;
}
