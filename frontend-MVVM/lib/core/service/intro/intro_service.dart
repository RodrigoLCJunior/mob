/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Serviço da Intro screen
 ** Obs...:
 */

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:midnight_never_end/data/repositories/user/user_repository.dart';

class IntroService {
  final Logger logger = Logger();

  // Áudio
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();
  bool _isMusicPlaying = false;
  bool _showAudioPrompt = false;
  bool _hasPlayedPressHereSound =
      false; // Adicionado para rastrear o som do "PRESS HERE"

  // KeepAlive
  Timer? _keepAliveTimer;

  // Tamanhos das imagens
  Size? _backgroundImageSize;
  Size? _backgroundImage2Size;

  IntroService() {
    logger.d("IntroService inicializado");
    playBackgroundMusic(); // Iniciar música diretamente
  }

  // Getters para os tamanhos das imagens
  Size? get backgroundImageSize => _backgroundImageSize;
  Size? get backgroundImage2Size => _backgroundImage2Size;

  bool get showAudioPrompt => _showAudioPrompt;
  bool get hasPlayedPressHereSound => _hasPlayedPressHereSound;

  // Métodos de áudio
  Future<void> playBackgroundMusic() async {
    if (_isMusicPlaying) {
      logger.d(
        "Música já está tocando, ignorando tentativa de iniciar novamente",
      );
      return;
    }

    try {
      logger.d("Tentando tocar música de fundo...");
      await _musicPlayer.stop();
      await _musicPlayer.setSource(AssetSource('audios/sons_of_liberty.mp3'));
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.5);
      await _musicPlayer.resume();
      _isMusicPlaying = true;
      _showAudioPrompt = false;
      logger.d("Música iniciada com sucesso: sons_of_liberty.mp3");
    } catch (e, stackTrace) {
      logger.e("Erro ao tocar música de fundo: $e\n$stackTrace");
      if (e.toString().contains("NotAllowedError")) {
        logger.w(
          "Reprodução automática bloqueada pelo navegador. Aguardando interação do usuário...",
        );
        _showAudioPrompt = true;
        return;
      }
      throw Exception("Erro ao tocar música de fundo: $e");
    }
  }

  Future<void> playThunderSound() async {
    try {
      logger.d("Tentando tocar o trovão...");
      await _audioPlayer.stop();
      await _audioPlayer.setSource(AssetSource('audios/thunder.wav'));
      await _audioPlayer.resume();
      logger.d("Trovão tocado com sucesso");
      // Tentar retomar a música de fundo após interação do usuário
      if (!_isMusicPlaying && _showAudioPrompt) {
        logger.d(
          "Interação do usuário detectada (trovão). Tentando retomar música de fundo...",
        );
        await playBackgroundMusic();
      }
    } catch (e, stackTrace) {
      logger.e("Erro ao tocar trovão: $e\n$stackTrace");
      if (e.toString().contains("NotAllowedError")) {
        logger.w(
          "Reprodução do trovão bloqueada pelo navegador. O som tocará após interação do usuário.",
        );
        return;
      }
      throw Exception("Erro ao tocar trovão: $e");
    }
  }

  Future<void> playPressHereSound() async {
    try {
      logger.d("Tentando tocar o som de press_here...");
      await _audioPlayer.stop();
      await _audioPlayer.setSource(AssetSource('audios/press_here.wav'));
      await _audioPlayer.resume();
      _hasPlayedPressHereSound = true; // Marcar como tocado
      logger.d("Som de press_here tocado com sucesso");
      // Tentar retomar a música de fundo após interação do usuário
      if (!_isMusicPlaying && _showAudioPrompt) {
        logger.d(
          "Interação do usuário detectada (press_here). Tentando retomar música de fundo...",
        );
        await playBackgroundMusic();
      }
    } catch (e, stackTrace) {
      logger.e("Erro ao tocar press_here: $e\n$stackTrace");
      if (e.toString().contains("NotAllowedError")) {
        logger.w(
          "Reprodução do som press_here bloqueada pelo navegador. O som tocará após interação do usuário.",
        );
        return;
      }
      throw Exception("Erro ao tocar press_here: $e");
    }
  }

  void resetPressHereSound() {
    _hasPlayedPressHereSound = false;
    logger.d("Estado do som de press_here resetado");
  }

  Future<void> pauseMusic() async {
    if (_isMusicPlaying) {
      await _musicPlayer.pause();
      logger.d("Música pausada");
    }
  }

  Future<void> resumeMusic() async {
    if (_isMusicPlaying) {
      await _musicPlayer.resume();
      logger.d("Música retomada");
    } else {
      await playBackgroundMusic();
    }
  }

  Future<void> stopMusic() async {
    await _musicPlayer.stop();
    _isMusicPlaying = false;
    logger.d("Música parada");
  }

  // Ping ao backend
  Future<void> pingBackend() async {
    try {
      final stopwatch = Stopwatch()..start();
      await BackendPinger.pingBackend();
      stopwatch.stop();
      logger.d(
        "Ping inicial - Tempo total: ${stopwatch.elapsed.inMilliseconds / 1000} segundos",
      );
    } catch (e, stackTrace) {
      logger.e("Erro ao pingar o backend: $e\n$stackTrace");
      throw Exception("Erro ao pingar o backend: $e");
    }
  }

  // Keep-alive
  void startKeepAlive() {
    try {
      _keepAliveTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
        BackendPinger.pingBackend();
        logger.d("Keep-alive ping enviado em ${DateTime.now()}");
      });
    } catch (e, stackTrace) {
      logger.e("Erro no startKeepAlive: $e\n$stackTrace");
      throw Exception("Erro no startKeepAlive: $e");
    }
  }

  // Carregar tamanhos das imagens
  Future<void> loadAllImageSizes() async {
    try {
      _backgroundImageSize = await _loadImageSizeForPath(
        "assets/images/background_image.png",
      );
      logger.d(
        "Tamanho da background_image carregado: ${_backgroundImageSize!.width}x${_backgroundImageSize!.height}",
      );

      _backgroundImage2Size = await _loadImageSizeForPath(
        "assets/images/background_image2.png",
      );
      logger.d(
        "Tamanho da background_image2 carregado: ${_backgroundImage2Size!.width}x${_backgroundImage2Size!.height}",
      );
    } catch (e, stackTrace) {
      logger.e("Erro ao carregar tamanhos das imagens: $e\n$stackTrace");
      throw Exception("Erro ao carregar tamanhos das imagens: $e");
    }
  }

  Future<Size> _loadImageSizeForPath(String imagePath) async {
    final imageProvider = AssetImage(imagePath);
    final imageStream = imageProvider.resolve(ImageConfiguration());
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

  // Dispose
  void dispose() {
    _keepAliveTimer?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _musicPlayer.stop();
    _musicPlayer.dispose();
    _isMusicPlaying = false;
    logger.d("IntroService disposed - Música e recursos liberados");
  }
}
