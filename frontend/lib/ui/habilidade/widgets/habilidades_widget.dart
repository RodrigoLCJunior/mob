import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/domain/entities/core/request_state_entity.dart';
import 'package:midnight_never_end/domain/entities/habilidades/habilidades_entity.dart';
import 'package:midnight_never_end/domain/error/core/habilidade_exception.dart';
import 'package:midnight_never_end/ui/habilidade/view_model/habilidade_view_model.dart';
import 'package:midnight_never_end/ui/habilidade/widgets/insufficient_coins_dialog.dart';
import 'package:midnight_never_end/ui/habilidade/widgets/talent_title.dart';

class HabilidadesWidget extends StatefulWidget {
  const HabilidadesWidget({super.key});

  @override
  State<HabilidadesWidget> createState() => _HabilidadesWidgetState();
}

class _HabilidadesWidgetState extends State<HabilidadesWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<HabilidadesViewModel>().preloadResources(context);
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HabilidadesViewModel, IRequestState<String>>(
      listener: (context, state) {
        if (state is RequestErrorState && state.error is HabilidadeException) {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return const InsufficientCoinsDialog();
            },
          );
        }
      },
      builder: (context, state) {
        final viewModel = context.read<HabilidadesViewModel>();
        final entity = viewModel.entity;

        return DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 0.5,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  border: Border.all(
                    color: Colors.cyanAccent.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: ListView.builder(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  itemCount: entity.talents.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildHeader(entity);
                    if (index == 1) return _buildCoinDisplay(entity);
                    final talentIndex = index - 2;
                    final talent = entity.talents[talentIndex];
                    return TalentTile(
                      icon: talent["icon"],
                      title: talent["title"],
                      level: talent["level"],
                      cost: talent["cost"],
                      onPressed: () => viewModel.upgradeTalent(talentIndex),
                      glowAnimation: null,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(HabilidadeEntity entity) {
    return Column(
      children: [
        Center(
          child: Text(
            "TALENTOS${entity.userName != null ? ' de ${entity.userName}' : ''}",
            style: const TextStyle(
              fontFamily: "Cinzel",
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            "Talentos podem fazer com que você\nfique mais forte permanentemente!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Cinzel",
              fontSize: 16,
              color: Colors.cyanAccent,
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCoinDisplay(HabilidadeEntity entity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/permCoin.png',
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 10),
        Text(
          '${entity.coins}',
          style: const TextStyle(
            fontFamily: "Cinzel",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
      ],
    );
  }
}
