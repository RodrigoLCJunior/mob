import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:midnight_never_end/data/repositories/game/game_repository_factory.dart';
import 'package:midnight_never_end/data/repositories/user/usuario_repository.dart';
import 'package:midnight_never_end/domain/entities/core/audio_manager_entity.dart';
import 'package:midnight_never_end/domain/entities/core/request_state_entity.dart';
import 'package:midnight_never_end/domain/entities/game_start/game_start_entity.dart';
import 'package:midnight_never_end/domain/error/core/game_start_exception.dart';
import 'package:midnight_never_end/game/screens/user_loading_screen.dart';
import 'package:midnight_never_end/ui/habilidade/pages/habilidade_modal.dart';
import 'package:midnight_never_end/ui/opcoes_conta/widgets/opcoes_conta.dart';

class GameStartViewModel extends Cubit<IRequestState<String>> {
  final UserRepository _userRepository;
  final AudioManager _audioManager;

  GameStartEntity _entity = GameStartEntity();

  GameStartViewModel({
    required UserRepository userRepository,
    required AudioManager audioManager,
  }) : _userRepository = userRepository,
       _audioManager = audioManager,
       super(const RequestInitiationState());

  GameStartEntity get entity => _entity;

  Future<void> initialize(BuildContext context) async {
    try {
      _emitter(const RequestProcessingState(value: "Inicializando..."));

      await _precacheImages(context);
      final usuario = await _userRepository.carregarUsuario();

      final adventures = [
        Adventure(
          title: "A Floresta Sombria",
          description: "Uma jornada inicial cheia de mistérios.",
          imagePath: "assets/images/mini_dungeons/book.png",
          isLocked: false,
        ),
        Adventure(
          title: "Noite Eterna",
          description: "Enfrente desafios sob a luz da lua.",
          imagePath: "assets/images/mini_dungeons/calice.png",
          isLocked: true,
        ),
        Adventure(
          title: "Abismo Esquecido",
          description: "Descubra segredos antigos.",
          imagePath: "assets/images/mini_dungeons/dagger.png",
          isLocked: true,
        ) /*,
        Adventure(
          title: "Coração da Escuridão",
          description: "A aventura suprema.",
          imagePath: "assets/images/mini_dungeons/dungeon_4.png",
          isLocked: true,
        ),
        Adventure(
          title: "Rastro do Caos",
          description: "Sobreviva ao imprevisível.",
          imagePath: "assets/images/mini_dungeons/dungeon_5.png",
          isLocked: true,
        ),*/,
      ];

      _entity = _entity.copyWith(
        usuario: usuario,
        adventures: adventures,
        isLoading: false,
      );

      _emitter(const RequestCompletedState(value: "Inicialização concluída"));
    } catch (e) {
      _entity = _entity.copyWith(isLoading: false);
      final errorMessage = createErrorDescription(e);
      showSnackBar(errorMessage, context);
      _emitter(RequestErrorState(error: e, value: errorMessage));
    }
  }

  Future<void> playMusic() async {
    try {
      await _audioManager.playMusic(
        'audios/game_background.mp3',
        loop: true,
        volume: 0.3,
        onUpdate: (isPlaying) {
          _entity = _entity.copyWith(isMusicPlaying: isPlaying);
        },
      );
    } catch (e) {
      final errorMessage = createErrorDescription(e);
      _emitter(RequestErrorState(error: e, value: errorMessage));
    }
  }

  Future<void> stopMusic() async {
    try {
      print('Stopping music in GameStartViewModel');
      await _audioManager.stopMusic();
      _entity = _entity.copyWith(isMusicPlaying: false);
    } catch (e) {
      final errorMessage = createErrorDescription(e);
      print('Error stopping music: $errorMessage');
      _emitter(RequestErrorState(error: e, value: errorMessage));
    }
  }

  Future<void> startAdventure(int index, BuildContext context) async {
    try {
      _emitter(
        RequestProcessingState(value: "Iniciando aventura ${index + 1}..."),
      );

      final selectedAdventure = _entity.adventures[index];

      if (selectedAdventure.isLocked) {
        showSnackBar('Esta aventura está bloqueada!', context);
        return;
      }

      await _audioManager.playSound('audios/pop.wav');
      showSnackBar('Iniciando aventura ${index + 1}...', context);

      // Novo passo: parar a música de fundo antes de trocar de tela
      await stopMusic();

      final usuario = _entity.usuario;
      if (usuario == null) {
        showSnackBar('Erro: Usuário não encontrado.', context);
        return;
      }

      // Cria o GameRepository assincronamente
      final gameRepository = await GameRepositoryFactory.create();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (_) => UserLoadingScreen(
                usuario: usuario,
                gameRepository: gameRepository, // passando a instância criada
              ),
        ),
      );

      _emitter(const RequestCompletedState(value: "Aventura iniciada"));
    } catch (e) {
      final errorMessage = createErrorDescription(e);
      showSnackBar(errorMessage, context);
      _emitter(RequestErrorState(error: e, value: errorMessage));
    }
  }

  Future<void> openAccountOptions(BuildContext context) async {
    try {
      _emitter(
        const RequestProcessingState(value: "Abrindo opções da conta..."),
      );
      await _audioManager.playSound('audios/tec.wav');
      showAccountOptions(
        context,
        _entity.usuario?.nome ?? "Usuário",
        () => _emitter(
          const RequestCompletedState(value: "Opções da conta abertas"),
        ),
        this,
      );
      _emitter(const RequestCompletedState(value: "Opções da conta abertas"));
    } catch (e) {
      final errorMessage = createErrorDescription(e);
      showSnackBar(errorMessage, context);
      _emitter(RequestErrorState(error: e, value: errorMessage));
    }
  }

  Future<void> openHabilidades(BuildContext context) async {
    try {
      _emitter(const RequestProcessingState(value: "Abrindo habilidades..."));
      await _audioManager.playSound('audios/tec.wav');
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HabilidadesPage()),
      );
      _emitter(const RequestCompletedState(value: "Habilidades abertas"));
    } catch (e) {
      final errorMessage = createErrorDescription(e);
      showSnackBar(errorMessage, context);
      _emitter(RequestErrorState(error: e, value: errorMessage));
    }
  }

  Future<void> openSettings(BuildContext context) async {
    try {
      _emitter(const RequestProcessingState(value: "Abrindo configurações..."));
      await _audioManager.playSound('audios/tec.wav');
      _emitter(
        const RequestErrorState(error: null, value: "Configurações em breve!"),
      );
      await Future.delayed(const Duration(seconds: 3));
      _emitter(const RequestCompletedState(value: "Configurações fechadas"));
    } catch (e) {
      final errorMessage = createErrorDescription(e);
      _emitter(RequestErrorState(error: e, value: errorMessage));
    }
  }

  Future<void> playScrollSound(BuildContext context) async {
    try {
      await _audioManager.playSound('audios/woosh.mp3');
    } catch (e) {
      final errorMessage = createErrorDescription(e);
      _emitter(RequestErrorState(error: e, value: errorMessage));
    }
  }

  void handleAppLifecycleState(AppLifecycleState state) {
    try {
      _audioManager.handleAppLifecycleState(state, _entity.isMusicPlaying);
    } catch (e) {
      // Você pode logar aqui, mas como não temos context, não usamos snackbar.
      print('Erro no ciclo de vida: ${createErrorDescription(e)}');
    }
  }

  String createErrorDescription(Object? error) {
    if (error is GameStartException) return error.message;
    if (error is AudioFailure) return error.message;
    return 'Erro interno. Tente novamente.';
  }

  Future<void> _precacheImages(BuildContext context) async {
    try {
      for (int i = 1; i <= 5; i++) {
        await precacheImage(
          AssetImage("assets/images/mini_dungeons/dungeon_$i.png"),
          context,
        );
      }
      await precacheImage(
        AssetImage("assets/images/game_background.png"),
        context,
      );
      await precacheImage(AssetImage("assets/icons/permCoin.png"), context);
    } catch (e) {
      throw GameStartImageLoadFailure('Erro ao pré-carregar imagens');
    }
  }

  void _emitter(IRequestState<String> state) {
    if (isClosed) return;
    emit(state);
  }

  @override
  Future<void> close() {
    _audioManager.stopMusic();
    _audioManager.dispose();
    return super.close();
  }
}

void showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
