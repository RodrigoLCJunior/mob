import 'package:audioplayers/audioplayers.dart';
import '../enum/audio_type.dart';
import '../../utils/logger.dart';

class AudioService {
  final Map<String, AudioPlayer> _players = {};
  final Map<String, bool> _isPreloaded = {};

  Future<void> initialize() async {
    // Precarregar sons usados na IntroScreen
    await _preloadAudio('sons_of_liberty.mp3', AudioType.background);
    await _preloadAudio('thunder.wav', AudioType.effect);
    await _preloadAudio('press_here.wav', AudioType.effect);
  }

  Future<void> _preloadAudio(String assetPath, AudioType type) async {
    if (_isPreloaded[assetPath] == true) return;

    final player = AudioPlayer();
    _players[assetPath] = player;
    _isPreloaded[assetPath] = true;

    try {
      await player.setSource(AssetSource('audios/$assetPath'));
      if (type == AudioType.background) {
        await player.setReleaseMode(ReleaseMode.loop);
        await player.setVolume(
          0.5,
        ); // Definir volume padrão pra música de fundo
      }
    } catch (e, stackTrace) {
      Logger.error('Erro ao precarregar áudio: $assetPath', e, stackTrace);
    }
  }

  Future<void> playAudio(
    String assetPath,
    AudioType type, {
    double volume = 1.0,
  }) async {
    await _preloadAudio(assetPath, type);
    final player = _players[assetPath];
    if (player != null) {
      try {
        await player.setVolume(type == AudioType.background ? 0.5 : volume);
        await player.resume();
        Logger.log('Áudio tocado: $assetPath');
      } catch (e, stackTrace) {
        Logger.error('Erro ao tocar áudio: $assetPath', e, stackTrace);
      }
    }
  }

  Future<void> stopAudio(String assetPath) async {
    final player = _players[assetPath];
    if (player != null) {
      try {
        await player.stop();
        Logger.log('Áudio parado: $assetPath');
      } catch (e, stackTrace) {
        Logger.error('Erro ao parar áudio: $assetPath', e, stackTrace);
      }
    }
  }

  Future<void> dispose() async {
    for (var player in _players.values) {
      await player.dispose();
    }
    _players.clear();
    _isPreloaded.clear();
  }
}
