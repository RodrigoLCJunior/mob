import 'package:flutter/material.dart';
import 'package:midnight_never_end/views/pages/intro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Midnight Never End',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false, // Desativa a faixa "DEBUG"
      home: const IntroScreen(),
    );
  }
}
