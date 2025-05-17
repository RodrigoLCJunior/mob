import 'package:midnight_never_end/models/avatar.dart';
import 'package:midnight_never_end/models/moeda_permanente.dart'; // Adicionar esta importação

class Usuario {
  final String id;
  final String nome;
  final String email;
  final String senha;
  final Avatar? avatar;
  final MoedaPermanente? moedaPermanente;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.avatar,
    this.moedaPermanente,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    print('Usuario.fromJson - JSON: $json');
    dynamic avatarData = json['avatar'];
    Avatar? avatar;

    if (avatarData != null) {
      if (avatarData is Map<String, dynamic>) {
        avatar = Avatar.fromJson(avatarData);
      } else if (avatarData is String) {
        print('Usuario.fromJson - Avatar is a String, creating default Avatar');
        avatar = Avatar(id: avatarData, hp: 0, progressao: null, deck: []);
      } else {
        print(
          'Usuario.fromJson - Unexpected type for avatar: ${avatarData.runtimeType}',
        );
      }
    }

    return Usuario(
      id: json['id'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      email: json['email'] as String? ?? '',
      senha: json['senha'] as String? ?? '',
      avatar: avatar,
      moedaPermanente:
          json['moedaPermanente'] != null
              ? MoedaPermanente.fromJson(
                json['moedaPermanente'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'avatar': avatar?.toJson(),
      'moedaPermanente': moedaPermanente?.toJson(),
    };
  }
}
