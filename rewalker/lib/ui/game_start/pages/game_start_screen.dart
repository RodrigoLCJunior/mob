import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/domain/entities/core/request_state_entity.dart';
import 'package:midnight_never_end/ui/cadastro/widgets/global_message_error_widget.dart';
import 'package:midnight_never_end/ui/game_start/view_models/game_start_view_model.dart';
import 'package:midnight_never_end/ui/game_start/view_models/game_start_view_model_factory.dart';
import 'package:midnight_never_end/ui/game_start/widgets/adventure_carousel_widget.dart';
import 'package:midnight_never_end/ui/game_start/widgets/game_footer_widget.dart';
import 'package:midnight_never_end/ui/game_start/widgets/game_header_widget.dart';

class GameStartScreen extends StatefulWidget {
  const GameStartScreen({super.key});

  @override
  State<GameStartScreen> createState() => _GameStartScreenState();
}

class _GameStartScreenState extends State<GameStartScreen>
    with TickerProviderStateMixin {
  late final AnimationController glowController;
  late final Animation<double> glowAnimation;
  GameStartViewModel? _viewModel;

  @override
  void initState() {
    super.initState();
    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: glowController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    glowController.dispose();
    _viewModel?.stopMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GameStartViewModel>(
      future: GameStartViewModelFactory.create(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        final viewModel = snapshot.data!;
        if (_viewModel == null) {
          _viewModel = viewModel;
          _viewModel!.initialize(context).then((_) {
            if (mounted) _viewModel!.playMusic();
          });
        }

        return BlocProvider.value(
          value: viewModel,
          child: BlocConsumer<GameStartViewModel, IRequestState<String>>(
            listener: (context, state) {},
            builder: (context, state) {
              final entity = viewModel.entity;
              final errorMessage =
                  state is RequestErrorState ? state.dataOrNull : null;

              return Scaffold(
                backgroundColor: Colors.black,
                body: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/background_image3.png"),
                      fit: BoxFit.cover,
                      opacity: 0.8,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child:
                          entity.isLoading
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GlobalErrorMessageWidget(
                                    errorMessage: errorMessage,
                                  ),
                                  GameHeader(
                                    glowAnimation: glowAnimation,
                                    userName: entity.usuario?.nome ?? "Usuário",
                                    onAccountOptionsTap:
                                        () => viewModel.openAccountOptions(
                                          context,
                                        ),
                                  ),
                                  Expanded(
                                    child: AdventureCarousel(
                                      onAdventureTap:
                                          (index) => viewModel.startAdventure(
                                            index,
                                            context,
                                          ),
                                      glowAnimation: glowAnimation,
                                      adventures: entity.adventures,
                                      isLoading: entity.isLoading,
                                      playScrollSound:
                                          (context) => viewModel
                                              .playScrollSound(context),
                                    ),
                                  ),
                                  GameFooter(
                                    glowAnimation: glowAnimation,
                                    onHabilidadesPressed:
                                        (context) =>
                                            viewModel.openHabilidades(context),
                                    onSettingsPressed:
                                        (context) =>
                                            viewModel.openSettings(context),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
