/*import 'package:midnight_never_end/data/repositories/user/user_repository.dart';
import 'package:midnight_never_end/data/repositories/progressao/progressao_repository.dart';
import 'package:midnight_never_end/data/repositories/moeda_permanente/moeda_permanente_repository.dart';
import 'package:midnight_never_end/data/repositories/avatar/avatar_repository.dart';
import 'package:midnight_never_end/domain/usecases/criar_user.dart';
import 'package:midnight_never_end/domain/usecases/fazer_login.dart';
import 'package:midnight_never_end/ui/moeda_permanente/views_model/moeda_permanente_bloc.dart';
import 'package:midnight_never_end/ui/user/view_models/user_bloc.dart';
import 'package:midnight_never_end/ui/progressao/view_models/progressao_bloc.dart';
import 'package:midnight_never_end/ui/avatar/view_models/avatar_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDependencies {
  final UserRepository userRepository;
  final ProgressaoRepository progressaoRepository;
  final MoedaPermanenteRepository moedaPermanenteRepository;
  final AvatarRepository avatarRepository;

  AppDependencies({
    required this.userRepository,
    required this.progressaoRepository,
    required this.moedaPermanenteRepository,
    required this.avatarRepository,
  });

  List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider(
        create:
            (_) => UserBloc(
              criarUsuarioUseCase: CriarUsuarioUseCase(userRepository),
              fazerLoginUseCase: FazerLoginUseCase(userRepository),
            ),
      ),
      BlocProvider(create: (_) => ProgressaoBloc(progressaoRepository)),
      BlocProvider(
        create: (_) => MoedaPermanenteBloc(moedaPermanenteRepository),
      ),
      BlocProvider(create: (_) => AvatarBloc(avatarRepository)),
    ];
  }
}

Future<AppDependencies> setupDependencies() async {
  final userRepository = UserRepository(
    baseUrl: "https://mob-backend-ah3e.onrender.com/api/usuarios",
  );
  final progressaoRepository = ProgressaoRepository();
  final moedaPermanenteRepository = MoedaPermanenteRepository();
  final avatarRepository = AvatarRepository();

  return AppDependencies(
    userRepository: userRepository,
    progressaoRepository: progressaoRepository,
    moedaPermanenteRepository: moedaPermanenteRepository,
    avatarRepository: avatarRepository,
  );
}*/
