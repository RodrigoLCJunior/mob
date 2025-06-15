import 'package:flutter/material.dart';
import 'package:midnight_never_end/domain/entities/combat/combat_initial_data.dart';
import 'package:midnight_never_end/domain/entities/user/user_entity.dart';
import 'package:midnight_never_end/game/screens/combat/pages/combat_screen.dart';

class UserTransition extends PageRouteBuilder {
  final Usuario usuario;
  final CombatInitialData combatData;

  UserTransition({required this.usuario, required this.combatData})
    : super(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                CombatScreen(usuario: usuario, combatData: combatData),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInOut;
          var fadeTween = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).chain(CurveTween(curve: curve));
          var scaleTween = Tween<double>(
            begin: 0.95,
            end: 1.0,
          ).chain(CurveTween(curve: curve));

          return Stack(
            children: [
              FadeTransition(
                opacity: animation.drive(
                  Tween<double>(
                    begin: 1.0,
                    end: 0.0,
                  ).chain(CurveTween(curve: curve)),
                ),
                child: Container(color: Colors.black.withOpacity(0.8)),
              ),
              FadeTransition(
                opacity: animation.drive(fadeTween),
                child: ScaleTransition(
                  scale: animation.drive(scaleTween),
                  child: child,
                ),
              ),
            ],
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      );
}
