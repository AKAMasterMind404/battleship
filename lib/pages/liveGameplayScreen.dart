import 'package:battleships/api/games.dart';
import 'package:battleships/helpers/utils.dart';
import 'package:battleships/providers/game_list_provider.dart';
import 'package:battleships/views/PieChart.dart';
import 'package:flutter/material.dart';
import '../helpers/constants.dart';
import '../helpers/sharedPreferences.dart';

class LiveGamePlayScreen extends StatefulWidget {
  static String RouteName = "GamePlayScreen";
  String gameId;

  LiveGamePlayScreen({required this.gameId});

  @override
  State<LiveGamePlayScreen> createState() => _LiveGamePlayScreenState();
}

class _LiveGamePlayScreenState extends State<LiveGamePlayScreen> {
  Map gameDataMap = {};
  bool isLoading = true;
  String? placedAt;

  @override
  void initState() {
    super.initState();
    _loadGameData();
  }

  Future<dynamic> _loadGameData() async {
    GameAPI gameAPI = GameAPI();
    dynamic gameData;
    String accessToken =
        await SharedPreferencesService.getStringValueForKey(ACCESS_TOKEN);
    try {
      gameData = await gameAPI.getData(accessToken, widget.gameId);
      setState(() {
        gameDataMap = gameData;
      });
    } catch (e) {
      UtilService.showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
    return gameData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game #${widget.gameId}',
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 6,
                    // Increased by 1 for the blank first column
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    padding: const EdgeInsets.all(8.0),
                    children: List.generate(6, (row) {
                      return List.generate(6, (column) {
                        if (column == 0 && row == 0) {
                          return Container();
                        } else if (column == 0) {
                          // First column displays 'A' to 'E'
                          return SizedBox(
                            width: 60,
                            height: 60,
                            child: Center(
                              child: Text(
                                String.fromCharCode(64 + row),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        } else if (row == 0) {
                          // First row displays '1' to '5'
                          return SizedBox(
                            width: 60,
                            height: 60,
                            child: Center(
                              child: Text(
                                '$column',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        } else {
                          // Inner boxes must be empty
                          return InkWell(
                              onTap: () => _handleGridTap(column, row),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[200]!),
                                    color:
                                        _getColorBasedOnSelection(column, row)),
                                child:
                                    getIconBasedOnRowColumnAndMap(column, row),
                              ));
                        }
                      });
                    }).expand((element) => element).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    child: const Text('Submit'),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
    );
  }

  Color _getColorBasedOnSelection(int column, int row) {
    String char = String.fromCharCode(64 + row);
    String tile = "$char$column";
    Color color = placedAt == tile ? Colors.grey[300]! : Colors.transparent;
    return color;
  }

  PieChartWidget? getIconBasedOnRowColumnAndMap(int column, int row) {
    List shipsList = gameDataMap['ships'] ?? [];
    List sunkList = gameDataMap['sunk'] ?? [];
    List wrecksList = gameDataMap['wrecks'] ?? [];
    List shotsList = gameDataMap['shots'] ?? [];

    String char = String.fromCharCode(64 + row);
    String charData = "$char$column";

    List<String> shipData = [];

    if (shipsList.contains(charData)) {
      shipData.add("assets/battleship.png");
    }
    if (sunkList.contains(charData)) {
      shipData.add("assets/explode.png");
    }
    if (wrecksList.contains(charData)) {
      shipData.add("assets/sunk.png");
    }
    if (shotsList.contains(charData)) {
      if (!wrecksList.contains(charData) && !sunkList.contains(charData)) {
        shipData.add("assets/bomb.png");
      }
    }

    return PieChartWidget(segments: shipData);
  }

  void _handleGridTap(int column, int row) {
    String char = "${String.fromCharCode(64 + row)}$column";
    setState(() {
      placedAt = char;
    });
  }

  void _handleSubmit() async {
    if (placedAt == null) {
      UtilService.showSnackBar(context, "Select a tile to play a shot!");
      return;
    }

    setState(() {
      isLoading = true;
    });
    final accessToken =
        await SharedPreferencesService.getStringValueForKey(ACCESS_TOKEN);
    try {
      final data =
          await GameAPI().playTurn(accessToken, gameDataMap["_id"], placedAt!);
      // { message:"", sunk_ship: true, won: true }
      await _handlePostSubmit();
      if (data["won"] == true) {
        UtilService.showSnackBar(
            context, "The last ship has sunk! You have won");
      } else if (data["sunk_ship"] == true) {
        UtilService.showSnackBar(context, "Successfully sunk a ship!");
      } else if (data["sunk_ship"] == false) {
        UtilService.showSnackBar(context, "Shot missed!");
      } else {
        UtilService.showSnackBar(context, data["message"]);
      }
    } on Exception catch (e) {
      UtilService.showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _handlePostSubmit() async {
    final data = await _loadGameData();
    if ([1, 2].contains(data["status"])) {
      String result = data["position"] == data["status"] ? "Game Over! You Won!" : "Game Over! You Lost!";
      UtilService.showSnackBar(context, result);
    }

    await GameListProvider.loadGameListForUser(context);
  }
}
