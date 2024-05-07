import 'package:battleships/helpers/constants.dart';
import 'package:battleships/helpers/sharedPreferences.dart';
import 'package:flutter/material.dart';
import '../helpers/utils.dart';
import '../pages/homepage.dart';
import '../pages/loginOrRegisterPage.dart';

class Wrapper extends StatelessWidget {
  static const String RouteName = "Wrapper";

  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _loadAccessTokenIfExists(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for data
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Display an error message if an error occurs
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.hasData) {
                final isExpired = UtilService.isAccessTokenExpired(snapshot.data!);
                return HomePage(isSessionExpired: isExpired);
              } else {
                return LoginOrRegisterPage();
              }
            }
          }),
    );
  }

  Future<String?> _loadAccessTokenIfExists(BuildContext context) async {
    try {
      final accessToken = await SharedPreferencesService.getStringValueForKey(ACCESS_TOKEN);
      return accessToken;
    } catch (e) {
      throw Exception(e);
    }
  }
}
