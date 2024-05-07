import 'dart:convert';
import 'package:battleships/helpers/utils.dart';
import 'package:http/http.dart' as http;
import 'package:battleships/helpers/constants.dart';

class GameAPI {
  Future<dynamic> getData(String accessToken, int? id) async {
    final url = "$baseUrl/games${id != null ? "/$id" : ""}";
    final data = await http.get(
      Uri.parse(url),
      headers: UtilService.getBearerHeaders(accessToken),
    );
    final decodedData = jsonDecode(data.body);
    if (data.statusCode >= 400) {
      throw Exception(decodedData["error"]);
    }

    return decodedData;
  }

  Future<dynamic> delete(String accessToken, String id) async {
    final url = "$baseUrl/games/$id";
    final data = await http.delete(
      Uri.parse(url),
      headers: UtilService.getBearerHeaders(accessToken),
    );

    final decodedData = jsonDecode(data.body);
    if (data.statusCode >= 400) {
      throw Exception(decodedData["error"]);
    }

    return decodedData;
  }

  Future<dynamic> create(
      String accessToken, List<String> ships, String? ai) async {
    const url = "$baseUrl/games";
    final body = ai == null ? {"ships": ships} : {"ships": ships, "ai": ai};
    final data = await http.post(Uri.parse(url),
        headers: UtilService.getBearerHeaders(accessToken),
        body: jsonEncode(body));

    final decodedData = jsonDecode(data.body);
    if (data.statusCode >= 400) {
      throw Exception(decodedData["error"]);
    }

    return decodedData;
  }

  Future<dynamic> playTurn(String accessToken, int gameId, String shot) async {
    final url = "$baseUrl/games/$gameId";
    final body = {"shot": shot};
    final data = await http.put(Uri.parse(url),
        headers: UtilService.getBearerHeaders(accessToken),
        body: jsonEncode(body));

    final decodedData = jsonDecode(data.body);
    if (data.statusCode >= 400) {
      throw Exception(decodedData["error"]);
    }

    return decodedData;
  }
}
