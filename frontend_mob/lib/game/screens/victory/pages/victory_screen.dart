import 'package:flutter/material.dart';
import 'package:midnight_never_end/game/screens/victory/widgets/victory_menu_button_widget.dart';
import 'package:midnight_never_end/game/screens/victory/widgets/victory_message_text_widget.dart';
import 'package:midnight_never_end/game/screens/victory/widgets/victory_title_text_widget.dart';

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            VictoryTitleText(),
            SizedBox(height: 20),
            VictoryMessageText(),
            SizedBox(height: 40),
            VictoryMenuButton(),
          ],
        ),
      ),
    );
  }
}
