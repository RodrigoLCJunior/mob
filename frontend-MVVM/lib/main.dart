import 'package:flutter/material.dart';
import 'package:midnight_never_end/data/repositories/user/user_repository.dart';
import 'package:midnight_never_end/ui/intro/pages/intro_screen.dart';
//import 'package:shared_preferences/shared_preferences.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  

  WidgetsFlutterBinding.ensureInitialized();
  //final prefs = await SharedPreferences.getInstance();
  await UserManager.loadUser(); // <- carregar usuário salvo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Rewalker Midnight',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const IntroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}