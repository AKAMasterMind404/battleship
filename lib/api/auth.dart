import 'dart:convert';
import 'package:battleships/helpers/utils.dart';
import 'package:http/http.dart' as http;
import 'package:battleships/helpers/constants.dart';

class AuthAPI {
  Future<dynamic> register(String username, String password) async {
    const url = "$baseUrl/auth/register";
    final body = jsonEncode({"username": username, "password": password});

    final data = await http.post(
      Uri.parse(url),
      headers: UtilService.getBasicHeaders,
      body: body,
    );

    final decodedData = jsonDecode(data.body);
    if (data.statusCode >= 400) {
      throw Exception(decodedData["error"]);
    }

    return decodedData;
  }

  Future<dynamic> login(String username, String password) async {
    const url = "$baseUrl/auth/login";
    final body = jsonEncode({"username": username, "password": password});
    print(url);

    final data = await http.post(
      Uri.parse(url),
      headers: UtilService.getBasicHeaders,
      body: body,
    );

    final decodedData = jsonDecode(data.body);
    if (data.statusCode >= 400) {
      throw Exception(decodedData["error"]);
    }

    return decodedData;
  }
}
