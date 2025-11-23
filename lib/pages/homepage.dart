import 'package:battleships/api/games.dart';
import 'package:battleships/helpers/constants.dart';
import 'package:battleships/helpers/sharedPreferences.dart';
import 'package:battleships/helpers/utils.dart';
import 'package:battleships/models/gameModel.dart';
import 'package:battleships/providers/game_list_provider.dart';
import 'package:battleships/views/drawer.dart';
import 'package:battleships/views/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/views/gameList.dart';

class HomePage extends StatefulWidget {
  final bool isSessionExpired;
  static const String RouteName = "HomePage";

  HomePage({this.isSessionExpired = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List gameList = [];
  String userName = "User";

  @override
  void initState() {
    super.initState();
    if (widget.isSessionExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        UtilService.logout(context);
        UtilService.showSnackBar(
            context, "Session has expired! Log in again to continue!");
        Navigator.pushReplacementNamed(context, Wrapper.RouteName);
      });
    }
    SharedPreferencesService.getStringValueForKey(USER_NAME).then((value) {
      userName = value;
      setState(() {});
    });
    GameListProvider.loadGameListForUser(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    GameListProvider provider = context.watch<GameListProvider>();
    List<GameModel> gameList = GameModel.getListFromJSON(provider.activeGameList);
    bool isLoading = provider.isListLoaded;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Battleships', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () => GameListProvider.loadGameListForUser(context),
              icon: const Icon(Icons.refresh))
        ],
        centerTitle: true,
      ),
      drawer: CustomDrawer(userName: userName),
      body: !isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: gameList.length,
              itemBuilder: (context, index) {
                GameModel gameModel = gameList[index];
                return GameStatusWidget(context, index + 1, gameModel);
              }),
    );
  }
}
