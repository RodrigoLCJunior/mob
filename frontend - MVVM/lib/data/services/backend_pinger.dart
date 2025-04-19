import 'package:http/http.dart' as http;
import '../../utils/logger.dart';
import 'api_config.dart';

class BackendPinger {
  static bool _isPinging = false;
  static DateTime? _lastPing;

  static Future<void> pingBackend() async {
    if (_isPinging ||
        (_lastPing != null &&
            DateTime.now().difference(_lastPing!).inSeconds < 30)) {
      return; // Evita ping se já foi feito recentemente
    }

    _isPinging = true;
    try {
      final stopwatch = Stopwatch()..start();
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/ping'))
          .timeout(ApiConfig.pingTimeout);
      stopwatch.stop();
      Logger.log("Ping - Status: ${response.statusCode}");
      Logger.log(
        "Ping - Tempo de resposta: ${stopwatch.elapsed.inMilliseconds / 1000} segundos",
      );
      if (response.statusCode == 200) {
        Logger.log("Backend acordado com sucesso!");
      } else {
        Logger.log("Ping retornou status inesperado: ${response.statusCode}");
      }
      _lastPing = DateTime.now();
    } catch (e) {
      Logger.error("Erro ao fazer ping no backend: $e");
    } finally {
      _isPinging = false;
    }
  }
}
