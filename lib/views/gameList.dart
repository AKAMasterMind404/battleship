import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/games.dart';
import '../helpers/constants.dart';
import '../helpers/sharedPreferences.dart';
import '../helpers/utils.dart';
import '../models/gameModel.dart';
import '../pages/liveGameplayScreen.dart';
import '../providers/game_list_provider.dart';

Widget GameStatusWidget(
  BuildContext context,
  GameModel currentGame,
  int index,
) {
  final gId = currentGame.id;
  final status = currentGame.status;

  String result = currentGame.position == currentGame.status ? "Won" : "Lost";
  final bool hasGameEnded = (status == 1 || status == 2);
  final String trailingStatus =
      !hasGameEnded
          ? currentGame.player2 == ''
              ? "Matchmaking"
              : "Ongoing"
          : result;
  final String currentMessageString =
      currentGame.status == 0
          ? currentGame.playerTurn ?? false ? "Your Turn to Play" : "Waiting for Opponent"
          : "${currentGame.player1} vs ${currentGame.player2}";

  return Dismissible(
    key: UniqueKey(),
    // Required for Dismissible widget
    direction:
        currentGame.status == 1
            ? DismissDirection.none
            : DismissDirection.startToEnd,
    // Specify the direction to dismiss
    onDismissed: (direction) => _deleteGame(context, gId),
    background: Container(
      color: Colors.red, // Background color when swiping
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20.0),
      child: const Icon(Icons.delete, color: Colors.white),
    ),
    child: ListTile(
      onTap:
          () => UtilService.pushRoute(context, LiveGamePlayScreen(gameId: gId)),
      leading: Text(
        "#${(index + 1).toString()}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      title: Text(currentMessageString),
      trailing: Text(trailingStatus),
    ),
  );
}

void _deleteGame(BuildContext context, String id) async {
  GameListProvider provider = context.read<GameListProvider>();
  GameAPI gameAPI = GameAPI();
  provider.updateIsLoadingStatus(true);
  try {
    final accessToken = await SharedPreferencesService.getStringValueForKey(
      ACCESS_TOKEN,
    );
    final data = await gameAPI.delete(accessToken, id.toString());
    UtilService.showSnackBar(context, "Game forfeited successfully!");
    await GameListProvider.loadGameListForUser(context);
  } catch (e) {
    UtilService.showSnackBar(context, e.toString());
  }
}
