import 'package:battleships/api/games.dart';
import 'package:battleships/helpers/constants.dart';
import 'package:battleships/helpers/sharedPreferences.dart';
import 'package:battleships/pages/completedGamesList.dart';
import 'package:battleships/views/AIDialog.dart';
import 'package:flutter/material.dart';
import '../helpers/utils.dart';
import '../pages/newGameplayScreen.dart';

class CustomDrawer extends StatefulWidget {
  final String? userName;

  const CustomDrawer({this.userName, Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            alignment: Alignment.center,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Battleships',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                widget.userName == null
                    ? const CircularProgressIndicator()
                    : Text(
                        'Logged in as ${widget.userName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('New game'),
            onTap: () {
              Navigator.pushNamed(context, NewGamePlayScreen.RouteName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.android),
            title: const Text('New Game (AI)'),
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AIGameDialog();
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu),
            title: const Text('Show Completed Games'),
            onTap: () {
              Navigator.of(context).pushNamed(CompletedGamesScreen.RouteName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              UtilService.logout(context);
            },
          ),
        ],
      ),
    );
  }

}
