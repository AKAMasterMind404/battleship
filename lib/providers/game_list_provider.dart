import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/games.dart';
import '../helpers/constants.dart';
import '../helpers/sharedPreferences.dart';

class GameListProvider extends ChangeNotifier {
  List _activeGameList = [];
  List get activeGameList => [..._activeGameList];

  List _inactiveGameList = [];
  List get inactiveGameList => [..._inactiveGameList];

  bool _isListLoaded = true;

  bool get isListLoaded => _isListLoaded;

  void addGameToList(dynamic game) {
    _activeGameList.add(game);
    notifyListeners();
  }

  void setGameList(List gameList) {
    final activeGames = [];
    final inactiveGames = [];

    for (int i = 0; i < gameList.length; i++) {
      final game = gameList[i];
      if ([1, 2].contains(game['status'])) {
        inactiveGames.add(game);
      } else {
        activeGames.add(game);
      }
    }

    _activeGameList = activeGames;
    _inactiveGameList = inactiveGames;
    notifyListeners();
  }

  void updateIsLoadingStatus(bool status) {
    _isListLoaded = status;
    notifyListeners();
  }

  static loadGameListForUser(BuildContext context) async {
    GameListProvider provider = context.read<GameListProvider>();
    final accessToken = await SharedPreferencesService.getStringValueForKey(ACCESS_TOKEN);
    provider.updateIsLoadingStatus(false);
    final GameAPI gameAPI = GameAPI();
    final data = await gameAPI.getData(accessToken, null);
    final gameList = data as List<dynamic>;
    provider.setGameList(gameList);
    provider.updateIsLoadingStatus(true);
  }
}
