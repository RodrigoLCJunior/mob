/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Repositorio de Metodos da Intro screen
 ** Obs...:
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// Interfaces dos Repositórios
abstract class AudioRepository {
  Future<void> playThunder();
  Future<void> playBackgroundMusic();
  Future<void> stopBackgroundMusic();
  Future<void> playPressHereSound();
}

abstract class ImageRepository {
  Future<Size> loadImageSize(String path);
}

abstract class BackendRepository {
  Future<void> pingBackend();
}

// Implementação do AudioRepository usando audioplayers
class AudioRepositoryImpl implements AudioRepository {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();
  bool _isMusicInitialized = false;

  @override
  Future<void> playThunder() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audios/thunder.wav'));
    } catch (e) {
      print("Erro ao tocar trovão: $e");
    }
  }

  @override
  Future<void> playBackgroundMusic() async {
    if (_isMusicInitialized) return; // Evita múltiplas inicializações
    try {
      await _musicPlayer.stop();
      await _musicPlayer.play(
        AssetSource('audios/sons_of_liberty.mp3'),
        mode: PlayerMode.mediaPlayer,
      );
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.5);
      _isMusicInitialized = true;
    } catch (e) {
      print("Erro ao tocar música de fundo: $e");
    }
  }

  @override
  Future<void> stopBackgroundMusic() async {
    try {
      await _musicPlayer.stop();
      _isMusicInitialized = false;
    } catch (e) {
      print("Erro ao parar música de fundo: $e");
    }
  }

  @override
  Future<void> playPressHereSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audios/press_here.wav'));
    } catch (e) {
      print("Erro ao tocar som 'Press Here': $e");
    }
  }
}

// Implementação real do ImageRepository
class ImageRepositoryImpl implements ImageRepository {
  @override
  Future<Size> loadImageSize(String path) async {
    final imageProvider = AssetImage(path);
    final imageStream = imageProvider.resolve(const ImageConfiguration());
    final completer = Completer<Size>();
    ImageStreamListener? listener;
    listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        completer.complete(
          Size(info.image.width.toDouble(), info.image.height.toDouble()),
        );
        imageStream.removeListener(listener!);
      },
      onError: (exception, stackTrace) {
        completer.completeError(exception, stackTrace);
      },
    );
    imageStream.addListener(listener);
    return await completer.future;
  }
}

// Implementação do BackendRepository
class BackendRepositoryImpl implements BackendRepository {
  @override
  Future<void> pingBackend() async {
    // Simulação: apenas loga a ação
    print("Ping ao backend (simulado)");
  }
}
