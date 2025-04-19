import '../../../domain/entities/user/user_entity.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}

class UserCreated extends UserState {
  final String message;

  UserCreated(this.message);
}

class UserLoggedIn extends UserState {
  final User user;

  UserLoggedIn(this.user);
}

class UserLoggedOut extends UserState {}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
