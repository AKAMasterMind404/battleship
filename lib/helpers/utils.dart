import 'package:battleships/helpers/constants.dart';
import 'package:battleships/helpers/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../views/wrapper.dart';

class UtilService {
  static get getBasicHeaders => {"Content-Type": "application/json"};

  static getBearerHeaders(String accessToken) => {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken"
      };

  static waitForSeconds(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
  }

  static pushRoute(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => widget));
  }

  static logout(BuildContext context) async {
    try {
      await SharedPreferencesService.deleteStringValueForKey(ACCESS_TOKEN);
      await SharedPreferencesService.deleteStringValueForKey(USER_NAME);
      Navigator.pushReplacementNamed(context, Wrapper.RouteName);
    } catch (e) {
      throw Exception(e);
    }
  }

  static bool isAccessTokenExpired(String accessToken) {
    final decodedToken = Jwt.parseJwt(accessToken);
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int expiryTimestamp = decodedToken["exp"];
    bool isExpired = currentTimestamp > expiryTimestamp;
    return isExpired;
  }

  static validateAuthTokenAndMakeAPICall(
      String accessToken, Function function) async {
    if (accessToken.isNotEmpty) {
    } else {
      throw Exception("Invalid Access token!");
    }

    await function();
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // Adjust as per your requirement
      ),
    );
  }
}
