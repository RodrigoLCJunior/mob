import 'package:flutter/material.dart';
import 'package:midnight_never_end/game/screens/defeat/widgets/defeat_menu_button_widget.dart';
import 'package:midnight_never_end/game/screens/defeat/widgets/defeat_message_text_widget.dart';
import 'package:midnight_never_end/game/screens/defeat/widgets/defeat_title_text_widget.dart';

class DefeatScreen extends StatelessWidget {
  const DefeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            DefeatTitleText(),
            SizedBox(height: 20),
            DefeatMessageText(),
            SizedBox(height: 40),
            DefeatMenuButton(),
          ],
        ),
      ),
    );
  }
}
