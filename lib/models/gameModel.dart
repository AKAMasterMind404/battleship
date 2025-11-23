class GameModel {
  final String id;
  final int status;
  final bool playerTurn;
  final int position;
  final String player1;
  final String player2;
  final List<String>? ships;
  final List<String>? shots;
  final List<String>? sunk;
  final List<String>? wrecks;

  GameModel({
    required this.id,
    required this.status,
    required this.playerTurn,
    required this.position,
    required this.player1,
    required this.player2,
    this.ships,
    this.shots,
    this.sunk,
    this.wrecks,
  });

  static GameModel fromJson(Map<String, Object?> json) => GameModel(
    id: json[GameFields.id] as String,
    status: json[GameFields.status] as int,
    playerTurn: json[GameFields.playerTurn] as bool,
    position: json[GameFields.position] as int,
    player1: json[GameFields.player1] as String,
    player2: (json[GameFields.player2] ?? "") as String,
    ships:
        json[GameFields.ships] == null
            ? null
            : List<String>.from(json[GameFields.ships] as List),

    shots:
        json[GameFields.shots] == null
            ? null
            : List<String>.from(json[GameFields.shots] as List),

    sunk:
        json[GameFields.sunk] == null
            ? null
            : List<String>.from(json[GameFields.sunk] as List),

    wrecks:
        json[GameFields.wrecks] == null
            ? null
            : List<String>.from(json[GameFields.wrecks] as List),
  );

  static List<GameModel> getListFromJSON(List jsonList) {
    List<GameModel> gameList =
        jsonList.map((json) => GameModel.fromJson(json)).toList();
    return gameList;
  }
}

class GameFields {
  static final List<String> values = [
    id,
    status,
    playerTurn,
    position,
    player1,
    player2,
    ships,
    shots,
    sunk,
    wrecks,
  ];

  static const String id = '_id';
  static const String status = 'status';
  static const String playerTurn = 'playerTurn';
  static const String position = 'position';
  static const String player1 = 'player1';
  static const String player2 = 'player2';
  static const String ships = 'ships';
  static const String shots = 'shots';
  static const String sunk = 'sunk';
  static const String wrecks = 'wrecks';
}
