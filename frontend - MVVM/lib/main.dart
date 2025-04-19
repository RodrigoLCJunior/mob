import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/config/app_config.dart';
import 'package:midnight_never_end/data/repositories/user/user_repository.dart';
import 'data/datasources/core/shared_preferences_datasource.dart';
import 'data/datasources/remote/remote_user_datasource.dart';
import 'domain/usecases/user/create_user.dart';
import 'domain/usecases/user/get_user.dart';
import 'domain/usecases/user/login_user.dart';
import 'domain/usecases/user/logout_user.dart';
import 'domain/usecases/user/update_user.dart';
import 'ui/intro/pages/intro_screen.dart';
import 'ui/user/view_models/user_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepositoryImpl(
      localDataSource: SharedPreferencesDataSource(AppConfig.sharedPreferences),
      remoteDataSource: RemoteUserDataSourceImpl(),
    );

    return BlocProvider(
      create:
          (context) => UserViewModel(
            getUser: GetUser(userRepository),
            updateUser: UpdateUser(userRepository),
            createUser: CreateUser(userRepository),
            loginUser: LoginUser(userRepository),
            logoutUser: LogoutUser(userRepository),
          ),
      child: MaterialApp(
        title: AppConfig.appName,
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: const IntroScreen(),
      ),
    );
  }
}
