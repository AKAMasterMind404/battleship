import 'package:flutter/material.dart';
import '../helpers/utils.dart';
import '../pages/newGameplayScreen.dart';

class AIGameDialog extends StatelessWidget {
  AIGameDialog();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Which AI do you want to play against?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              UtilService.pushRoute(
                  context, NewGamePlayScreen(gameType: "random"));
            },
            child: const Text('Random'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              UtilService.pushRoute(
                  context, NewGamePlayScreen(gameType: "perfect"));
            },
            child: const Text('Perfect'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              UtilService.pushRoute(
                  context, NewGamePlayScreen(gameType: "oneship"));
            },
            child: const Text('One ship (A1)'),
          ),
        ],
      ),
    );
  }
}
