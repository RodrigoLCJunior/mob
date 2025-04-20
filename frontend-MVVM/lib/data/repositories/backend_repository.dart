/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Repositorio de Metodos de Logger
 ** Obs...:
 */

import 'package:logger/logger.dart';

class BackendRepository {
  final Logger logger = Logger();

  Future<void> pingBackend() async {
    // Realiza o ping no backend.
    logger.d("Ping enviado ao backend.");
  }
}
