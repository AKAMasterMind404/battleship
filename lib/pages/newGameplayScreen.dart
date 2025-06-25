import 'package:battleships/api/games.dart';
import 'package:battleships/helpers/utils.dart';
import 'package:battleships/pages/liveGameplayScreen.dart';
import 'package:battleships/providers/game_list_provider.dart';
import 'package:flutter/material.dart';
import '/helpers/constants.dart';
import '/helpers/sharedPreferences.dart';

class NewGamePlayScreen extends StatefulWidget {
  static String RouteName = "GamePlayScreen";
  int? gameId;
  String? gameType;

  NewGamePlayScreen({this.gameId, this.gameType});

  @override
  State<NewGamePlayScreen> createState() => _NewGamePlayScreenState();
}

class _NewGamePlayScreenState extends State<NewGamePlayScreen> {
  final alphabetColumns = {};
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Ships', style: TextStyle(color: Colors.white)),
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
                                  border: Border.all(color: Colors.grey[200]!),
                                  color:
                                      _getColorBasedOnSelection(column, row)),
                            ),
                          );
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
    List selectedColorColumn = alphabetColumns[column] ?? [];
    String char = String.fromCharCode(64 + row);
    Color color = selectedColorColumn.contains(char)
        ? Colors.grey[300]!
        : Colors.transparent;
    return color;
  }

  List<String> _getSelectedTiles() {
    List<String> selectionTiles = [];
    for (var col in alphabetColumns.keys) {
      List selected = alphabetColumns[col];
      for (var row in selected) {
        String selection = "$row$col";
        selectionTiles.add(selection);
      }
    }
    return selectionTiles;
  }

  void _handleGridTap(int column, int row) {
    String char = "${String.fromCharCode(64 + row)}$column";
    List selectedTiles = _getSelectedTiles();

    bool isMaxSelected = _getSelectedTiles().length > 4;
    bool isCharAlreadySelected = selectedTiles.contains(char);

    bool isOverFlow = isMaxSelected && !isCharAlreadySelected;
    if (isOverFlow) {
      UtilService.showSnackBar(context, "You cannot select more than 5 tiles!");
      return;
    }
    _assignSelectionAndRefresh(column, row);
  }

  void _assignSelectionAndRefresh(int column, int row) {
    String char = String.fromCharCode(64 + row);
    List selectedColList = alphabetColumns[column] ?? [];
    if (selectedColList.contains(char)) {
      selectedColList.remove(char);
    } else {
      selectedColList.add(char);
    }
    alphabetColumns[column] = selectedColList;
    setState(() {});
  }

  void _handleSubmit() async {
    if (_getSelectedTiles().length < 5) {
      UtilService.showSnackBar(context, "Select atleast than 5 tiles!");
      return;
    }
    setState(() {
      isLoading = true;
    });
    final accessToken =
        await SharedPreferencesService.getStringValueForKey(ACCESS_TOKEN);
    List<String> shipList = _getSelectedTiles();
    try {
      dynamic data;
      if(widget.gameType != null) {
        data = await _createGameWithAI(widget.gameType!);
      } else {
        data = await GameAPI().create(accessToken, shipList, null);
      }
      await GameListProvider.loadGameListForUser(context);
      UtilService.showSnackBar(context, "Successfully created ships!");
      Navigator.of(context).pop();
      UtilService.pushRoute(context, LiveGamePlayScreen(gameId: data["_id"]));
    } on Exception catch (e) {
      UtilService.showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  _createGameWithAI(String type) async {
    GameAPI gameAPI = GameAPI();
    final accessToken = await SharedPreferencesService.getStringValueForKey(ACCESS_TOKEN);
    List<String> shipList = _getSelectedTiles();
    final ships = shipList;
    final game = await gameAPI.create(accessToken, ships, type);
    return game;
  }

}
