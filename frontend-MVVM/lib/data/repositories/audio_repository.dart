/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Repositorio de Metodos de Audio
 ** Obs...:
 */

import 'package:audioplayers/audioplayers.dart';

class AudioRepository {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();

  Future<void> playThunder() async {
    await _audioPlayer.setSource(AssetSource('audios/thunder.wav'));
    await _audioPlayer.resume();
  }

  Future<void> playPressHereSound() async {
    await _audioPlayer.setSource(AssetSource('audios/press_here.wav'));
    await _audioPlayer.resume();
  }

  Future<void> playBackgroundMusic() async {
    await _musicPlayer.setSource(AssetSource('audios/sons_of_liberty.mp3'));
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(0.5);
    await _musicPlayer.resume();
  }

  Future<void> stopBackgroundMusic() async {
    await _musicPlayer.stop();
  }
}
