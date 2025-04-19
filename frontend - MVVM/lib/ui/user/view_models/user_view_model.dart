import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/user/create_user.dart';
import '../../../domain/usecases/user/get_user.dart';
import '../../../domain/usecases/user/login_user.dart';
import '../../../domain/usecases/user/logout_user.dart';
import '../../../domain/usecases/user/update_user.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserViewModel extends Bloc<UserEvent, UserState> {
  final GetUser getUser;
  final UpdateUser updateUser;
  final CreateUser createUser;
  final LoginUser loginUser;
  final LogoutUser logoutUser;

  UserViewModel({
    required this.getUser,
    required this.updateUser,
    required this.createUser,
    required this.loginUser,
    required this.logoutUser,
  }) : super(UserInitial()) {
    on<FetchUserEvent>(_onFetchUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<CreateUserEvent>(_onCreateUser);
    on<LoginUserEvent>(_onLoginUser);
    on<LogoutUserEvent>(_onLogoutUser);
  }

  Future<void> _onFetchUser(
    FetchUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await getUser(event.userId);
    emit(
      result.fold(
        (failure) => UserError(failure.message),
        (user) => UserLoaded(user),
      ),
    );
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await updateUser(event.user);
    emit(
      result.fold(
        (failure) => UserError(failure.message),
        (user) => UserLoaded(user),
      ),
    );
  }

  Future<void> _onCreateUser(
    CreateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await createUser(
      CreateUserParams(
        nome: event.nome,
        email: event.email,
        senha: event.senha,
      ),
    );
    emit(
      result.fold(
        (failure) => UserError(failure.message),
        (_) => UserCreated('Usuário criado com sucesso'),
      ),
    );
  }

  Future<void> _onLoginUser(
    LoginUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await loginUser(
      LoginUserParams(email: event.email, senha: event.senha),
    );
    emit(
      result.fold(
        (failure) => UserError(failure.message),
        (user) => UserLoggedIn(user),
      ),
    );
  }

  Future<void> _onLogoutUser(
    LogoutUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await logoutUser(NoParams());
    emit(
      result.fold(
        (failure) => UserError(failure.message),
        (_) => UserLoggedOut(),
      ),
    );
  }
}
