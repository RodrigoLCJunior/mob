/*
 ** Task..: 30 - Padronização Frontend
 ** Data..: 24/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Padronizar o frontend
 ** Obs...: Criar a classe usuario
*/

import '../avatar/avatar_entity.dart';
import '../moeda_permanente/moeda_permanente_entity.dart';

class User {
  final String id; // UUID como String no Flutter
  final String nome;
  final String email;
  final String senha;
  final Avatar? avatar;
  final MoedaPermanente? moedaPermanente;

  User({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.avatar,
    this.moedaPermanente,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      senha: json['senha'] as String,
      avatar: json['avatar'] != null ? Avatar.fromJson(json['avatar']) : null,
      moedaPermanente:
          json['moedaPermanente'] != null
              ? MoedaPermanente.fromJson(json['moedaPermanente'])
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

  User copyWith({
    String? id,
    String? nome,
    String? email,
    String? senha,
    Avatar? avatar,
    MoedaPermanente? moedaPermanente,
  }) {
    return User(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      avatar: avatar ?? this.avatar,
      moedaPermanente: moedaPermanente ?? this.moedaPermanente,
    );
  }
}
