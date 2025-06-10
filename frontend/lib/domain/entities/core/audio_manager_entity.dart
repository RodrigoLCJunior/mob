// Gerencia áudio genérico (música e efeitos sonoros) com suporte a looping, volume e ciclo de vida.

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:midnight_never_end/domain/error/core/intro_exception.dart';

class AudioManager {
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _soundPlayer = AudioPlayer();

  Future<void> playMusic(
    String path, {
    bool loop = false,
    double volume = 1.0,
    required void Function(bool) onUpdate,
  }) async {
    try {
      await _musicPlayer.setSource(AssetSource(path));
      if (loop) await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(volume);
      await _musicPlayer.resume();
      onUpdate(true);
    } catch (e) {
      throw AudioFailure('Erro ao tocar música: $e');
    }
  }

  Future<void> playSound(String path) async {
    try {
      await _soundPlayer.stop();
      await _soundPlayer.setSource(AssetSource(path));
      await _soundPlayer.resume();
    } catch (e) {
      throw AudioFailure('Erro ao tocar som: $e');
    }
  }

  Future<void> stopMusic() async {
    try {
      await _musicPlayer.stop();
    } catch (e) {
      throw AudioFailure('Erro ao parar música: $e');
    }
  }

  void handleAppLifecycleState(
    AppLifecycleState state,
    bool isMusicPlaying,
  ) async {
    try {
      if (state == AppLifecycleState.paused && isMusicPlaying) {
        await _musicPlayer.pause();
      } else if (state == AppLifecycleState.resumed && isMusicPlaying) {
        await _musicPlayer.resume();
      }
    } catch (e) {
      throw AudioFailure('Erro ao gerenciar áudio no ciclo de vida: $e');
    }
  }

  void dispose() {
    _musicPlayer.stop();
    _musicPlayer.dispose();
    _soundPlayer.stop();
    _soundPlayer.dispose();
  }
}
