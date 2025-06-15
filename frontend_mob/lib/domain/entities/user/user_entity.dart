/*
 ** Task..: 30 - Padronização Frontend
 ** Data..: 24/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Padronizar o frontend
 ** Obs...: Criar a classe usuario
*/

import 'dart:convert';

import 'package:midnight_never_end/domain/entities/avatar/avatar_entity.dart';
import 'package:midnight_never_end/domain/entities/moeda_permanente/moeda_permanente_entity.dart';

final class Usuario {
  final String id;
  final String nome;
  final String email;
  final String senha;
  final Avatar? avatar;
  final MoedaPermanente? moedaPermanente;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.avatar,
    this.moedaPermanente,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    dynamic avatarData = json['avatar'];
    Avatar? avatar;

    if (avatarData != null) {
      if (avatarData is Map<String, dynamic>) {
        avatar = Avatar.fromJson(avatarData);
      } else if (avatarData is String) {
        avatar = Avatar(id: avatarData, hp: 0, progressao: null, deck: []);
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

  factory Usuario.fromRemoteMap(Map<String, dynamic> map) {
    return _fromMap(
      userMap: map,
      avatarMap: map[kKeyAvatar] as Map<String, dynamic>?,
      moedaPermanenteMap: map[kKeyMoedaPermanente] as Map<String, dynamic>?,
      avatarString: map[kKeyAvatar] as String?,
    );
  }

  factory Usuario.fromStorageMap(Map<String, dynamic> map) {
    return _fromMap(
      userMap: map,
      avatarMap:
          map[kKeyAvatar] != null
              ? jsonDecode(map[kKeyAvatar]) as Map<String, dynamic>
              : null,
      moedaPermanenteMap:
          map[kKeyMoedaPermanente] != null
              ? jsonDecode(map[kKeyMoedaPermanente]) as Map<String, dynamic>
              : null,
      avatarString: map[kKeyAvatar] as String?,
    );
  }

  static Usuario _fromMap({
    required Map<String, dynamic> userMap,
    Map<String, dynamic>? avatarMap,
    Map<String, dynamic>? moedaPermanenteMap,
    String? avatarString,
  }) {
    Avatar? avatar;
    if (avatarMap != null) {
      avatar = Avatar.fromJson(avatarMap);
    } else if (avatarString != null) {
      avatar = Avatar(id: avatarString, hp: 0, progressao: null, deck: []);
    }

    return Usuario(
      id: userMap[kKeyId] as String? ?? '',
      nome: userMap[kKeyNome] as String? ?? '',
      email: userMap[kKeyEmail] as String? ?? '',
      senha: userMap[kKeySenha] as String? ?? '',
      avatar: avatar,
      moedaPermanente:
          moedaPermanenteMap != null
              ? MoedaPermanente.fromMap(moedaPermanenteMap)
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      kKeyId: id,
      kKeyNome: nome,
      kKeyEmail: email,
      kKeySenha: senha,
      kKeyAvatar: avatar != null ? jsonEncode(avatar?.toMap()) : null,
      kKeyMoedaPermanente:
          moedaPermanente != null ? jsonEncode(moedaPermanente?.toMap()) : null,
    };
  }

  // Método para atualizar os dados do usuário sem modificar a instância original
  Usuario copyWith({
    String? id,
    String? nome,
    String? email,
    String? senha,
    Avatar? avatar,
    MoedaPermanente? moedaPermanente,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      avatar: avatar ?? this.avatar,
      moedaPermanente: moedaPermanente ?? this.moedaPermanente,
    );
  }

  static const String kKeyId = 'id';
  static const String kKeyNome = 'nome';
  static const String kKeyEmail = 'email';
  static const String kKeySenha = 'senha';
  static const String kKeyAvatar = 'avatar';
  static const String kKeyMoedaPermanente = 'moedaPermanente';
}
