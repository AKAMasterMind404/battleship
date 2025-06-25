class GameModel {
  final String id;
  final int status;
  final int position;
  final String player1;
  final String? player2;
  final List? ships;
  final List? shots;
  final List? sunk;
  final List? wrecks;
  final bool? playerTurn;

  GameModel({
    required this.id,
    required this.status,
    required this.position,
    required this.player1,
    required this.player2,
    this.ships,
    this.shots,
    this.sunk,
    this.wrecks,
    this.playerTurn,
  });

  static GameModel fromJson(Map<String, Object?> json) => GameModel(
    id: json[GameFields.id] as String,
    status: json[GameFields.status] as int,
    position: json[GameFields.position] as int,
    player1: json[GameFields.player1] as String,
    player2: (json[GameFields.player2] ?? "") as String,
    ships:
        json[GameFields.ships] != null ? json[GameFields.ships] as List : null,
    shots:
        json[GameFields.shots] != null ? json[GameFields.shots] as List : null,
    sunk: json[GameFields.sunk] != null ? json[GameFields.sunk] as List : null,
    wrecks:
        json[GameFields.wrecks] != null
            ? json[GameFields.wrecks] as List
            : null,
    playerTurn: json[GameFields.playerTurn] as bool,
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
    position,
    player1,
    player2,
    ships,
    shots,
    sunk,
    wrecks,
    playerTurn,
  ];

  static const String id = '_id';
  static const String status = 'status';
  static const String position = 'position';
  static const String player1 = 'player1';
  static const String player2 = 'player2';
  static const String ships = 'ships';
  static const String shots = 'shots';
  static const String sunk = 'sunk';
  static const String wrecks = 'wrecks';
  static const String playerTurn = 'playerTurn';
}
