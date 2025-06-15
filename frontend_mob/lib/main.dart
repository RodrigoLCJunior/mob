import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/ui/intro/pages/intro_page.dart';
import 'package:midnight_never_end/ui/intro/view_model/intro_view_model.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => IntroViewModel(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false, // Remove a faixa DEBUG
        home: IntroScreen(),
      ),
    ),
  );
}
