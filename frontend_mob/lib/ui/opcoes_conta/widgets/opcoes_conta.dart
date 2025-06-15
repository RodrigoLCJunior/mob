import 'package:flutter/material.dart';
import 'package:midnight_never_end/ui/game_start/view_models/game_start_view_model.dart';
import 'package:midnight_never_end/ui/opcoes_conta/pages/account_options_page.dart';

void showAccountOptions(
  BuildContext context,
  String userName,
  VoidCallback updateState,
  GameStartViewModel viewModel,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (context) =>
              AccountOptionsPage(userName: userName, viewModel: viewModel),
    ),
  ).then((_) => updateState());
}
