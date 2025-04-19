import '../../../domain/entities/user/user_entity.dart';

abstract class UserEvent {}

class FetchUserEvent extends UserEvent {
  final String userId;

  FetchUserEvent(this.userId);
}

class UpdateUserEvent extends UserEvent {
  final User user;

  UpdateUserEvent(this.user);
}

class CreateUserEvent extends UserEvent {
  final String nome;
  final String email;
  final String senha;

  CreateUserEvent(this.nome, this.email, this.senha);
}

class LoginUserEvent extends UserEvent {
  final String email;
  final String senha;

  LoginUserEvent(this.email, this.senha);
}

class LogoutUserEvent extends UserEvent {}
