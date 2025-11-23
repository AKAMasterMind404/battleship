import 'package:battleships/models/gameModel.dart';
import 'package:battleships/providers/game_list_provider.dart';
import 'package:battleships/views/gameList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompletedGamesScreen extends StatefulWidget {
  static String RouteName = "CompletedGamesScreen";
  int? gameId;

  CompletedGamesScreen({this.gameId});

  @override
  State<CompletedGamesScreen> createState() => _CompletedGamesScreenState();
}

class _CompletedGamesScreenState extends State<CompletedGamesScreen> {
  bool isLoading = false;
  List<GameModel> gameModelList = [];

  @override
  void initState() {
    GameListProvider gameListProvider = context.read<GameListProvider>();
    setState(() {
      List<GameModel> gameList =
          GameModel.getListFromJSON(gameListProvider.inactiveGameList);
      gameModelList = gameList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Games', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: gameModelList.length,
              itemBuilder: (BuildContext context, int index) {
                GameModel gameModel = gameModelList[index];
                return GameStatusWidget(context, index + 1, gameModel);
              }),
    );
  }
}
