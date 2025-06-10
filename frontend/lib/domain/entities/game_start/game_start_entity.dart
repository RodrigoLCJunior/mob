// Encapsula o estado compartilhado da tela inicial.

import 'package:midnight_never_end/domain/entities/user/user_entity.dart';

class GameStartEntity {
  final Usuario? usuario;
  final List<Adventure> adventures;
  final bool isLoading;
  final bool isMusicPlaying;

  GameStartEntity({
    this.usuario,
    this.adventures = const [],
    this.isLoading = false,
    this.isMusicPlaying = false,
  });

  GameStartEntity copyWith({
    Usuario? usuario,
    List<Adventure>? adventures,
    bool? isLoading,
    bool? isMusicPlaying,
  }) {
    return GameStartEntity(
      usuario: usuario ?? this.usuario,
      adventures: adventures ?? this.adventures,
      isLoading: isLoading ?? this.isLoading,
      isMusicPlaying: isMusicPlaying ?? this.isMusicPlaying,
    );
  }
}

class Adventure {
  final String title;
  final String description;
  final String imagePath;
  final bool isLocked;

  Adventure({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.isLocked,
  });
}
