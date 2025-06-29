﻿/*import 'package:flutter/material.dart';
import 'package:midnight_never_end/configs/injection_container.dart';
import 'package:midnight_never_end/core/service/app_service.dart';
import 'package:midnight_never_end/domain/entities/core/location_entity.dart';

final class RouteGeneratorHelper {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;
    return switch (settings.name) {
      kInitial => createRoutePage(const LoginPage()),
      kLogin => createRoutePage(const LoginPage()),
      kHome => createRoutePage(const UserPage()),
      kMapPage => createRoutePage(MapPage(locations: args as List<LocationEntity>)),
      _ => createRouteError(),
    };
  }

  static PageRoute createRoutePage(Widget widget) {
    return MaterialPageRoute(
      builder: (context) => widget,
    );
  }

  static Route<dynamic> createRouteError() {
    const String msg = 'Error Route';
    return MaterialPageRoute(
      builder: (context) {
        return const Scaffold(
          body: Center(
            child: Text(msg),
          ),
        );
      },
    );
  }

  static const String kInitial = '/';
  static const String kLogin = '/login';
  static const String kHome = '/home';
  static const String kMapPage = '/map-page';

  static void onRouteInitialization(String route) {
    if (route.isNotEmpty) getIt<IAppService>().navigateNamedReplacementTo(route);
  }
}*/
