import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:midnight_never_end/config/environment_helper.dart';
import 'package:midnight_never_end/core/service/app_service.dart';
import 'package:midnight_never_end/core/service/migrate_service.dart';
import 'package:midnight_never_end/core/service/storage_service.dart';
import 'package:midnight_never_end/data/datasources/user/usuario_datasource.dart';
import 'package:midnight_never_end/data/repositories/user/usuario_repository.dart';
import 'package:midnight_never_end/ui/cadastro/view_models/cadastro_view_model.dart';
import 'package:midnight_never_end/ui/intro/view_model/intro_view_model.dart';
import 'package:midnight_never_end/ui/login/view_model/login_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  /// #region EnvironmentHelper
  final IEnvironmentHelper environmentHelper = EnvironmentHelper();
  getIt.registerSingleton<IEnvironmentHelper>(environmentHelper);

  /// #region AppService
  getIt.registerSingleton<IAppService>(AppService(GlobalKey<NavigatorState>()));

  /// #region StorageService
  getIt.registerSingleton<IStorageService>(
    StorageService(MigrateService(), await SharedPreferences.getInstance()),
  );

  getIt.registerSingleton<UsuarioDataSource>(
    UsuarioDataSource(
      client: getIt<http.Client>(),
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  getIt.registerSingleton<UserRepository>(
    UserRepository(dataSource: getIt<UsuarioDataSource>()),
  );
  getIt.registerSingleton<IntroViewModel>(IntroViewModel());
  //getIt.registerFactory<LoginViewModel>(() => LoginViewModel());
  //getIt.registerFactory<CadastroViewModel>(() => CadastroViewModel());
}
