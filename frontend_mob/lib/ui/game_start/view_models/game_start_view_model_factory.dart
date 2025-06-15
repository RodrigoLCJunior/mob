import 'package:midnight_never_end/data/repositories/user/usuario_repository_factory.dart';
import 'package:midnight_never_end/domain/entities/core/audio_manager_entity.dart';
import 'package:midnight_never_end/ui/game_start/view_models/game_start_view_model.dart';

class GameStartViewModelFactory {
  static Future<GameStartViewModel> create() async {
    final userRepository = await UserRepositoryFactory.create();
    final audioManager = AudioManager();
    return GameStartViewModel(
      userRepository: userRepository,
      audioManager: audioManager,
    );
  }
}
