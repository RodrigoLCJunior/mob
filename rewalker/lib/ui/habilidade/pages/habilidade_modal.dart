import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/ui/habilidade/view_model/habilidade_view_model.dart';
import 'package:midnight_never_end/ui/habilidade/widgets/habilidades_widget.dart';

class HabilidadesPage extends StatelessWidget {
  const HabilidadesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HabilidadesViewModel(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Habilidades',
            style: TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
        ),
        body: const HabilidadesWidget(),
      ),
    );
  }
}
