class GameModel {
  final int id;
  final int status;
  final int turn;
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
    required this.turn,
    required this.position,
    required this.player1,
    required this.player2,
    this.ships,
    this.shots,
    this.sunk,
    this.wrecks,
  });

  static GameModel fromJson(Map<String, Object?> json) => GameModel(
        id: json[GameFields.id] as int,
        status: json[GameFields.status] as int,
        turn: json[GameFields.turn] as int,
        position: json[GameFields.position] as int,
        player1: json[GameFields.player1] as String,
        player2: (json[GameFields.player2] ?? "") as String,
        ships: json[GameFields.ships] != null
            ? json[GameFields.ships] as List<String>
            : null,
        shots: json[GameFields.shots] != null
            ? json[GameFields.shots] as List<String>
            : null,
        sunk: json[GameFields.sunk] != null
            ? json[GameFields.sunk] as List<String>
            : null,
        wrecks: json[GameFields.wrecks] != null
            ? json[GameFields.wrecks] as List<String>
            : null,
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
    turn,
    position,
    player1,
    player2,
    ships,
    shots,
    sunk,
    wrecks,
  ];

  static const String id = 'id';
  static const String status = 'status';
  static const String turn = 'turn';
  static const String position = 'position';
  static const String player1 = 'player1';
  static const String player2 = 'player2';
  static const String ships = 'ships';
  static const String shots = 'shots';
  static const String sunk = 'sunk';
  static const String wrecks = 'wrecks';
}
