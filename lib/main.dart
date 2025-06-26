import 'dart:async';
import 'pages/completedGamesList.dart';
import 'pages/newGameplayScreen.dart';
import 'providers/game_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/homepage.dart';
import 'views/wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GameListProvider())],
      child: MaterialApp(
        title: 'Google Sign In',
        home: const Wrapper(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          fontFamily: 'Montserrat',

          textTheme: const TextTheme(
            displayLarge:
                TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),

          // Define the default ButtonTheme. Use this to specify the default
          // button styling.
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            buttonColor: Colors.blue,
          ),

          // Define the default AppBarTheme. Use this to specify the default
          // AppBar styling.
          appBarTheme: const AppBarTheme(
            color: Colors.blue,
            iconTheme: IconThemeData(color: Colors.white),
          ),

          // Define the default IconTheme. Use this to specify the default
          // icon styling.
          iconTheme: const IconThemeData(
            color: Colors.blue,
          ),

          // Define the default FloatingActionButtonTheme. Use this to specify
          // the default FloatingActionButton styling.
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        routes: {
          Wrapper.RouteName: (ctx) => const Wrapper(),
          HomePage.RouteName: (ctx) => HomePage(),
          NewGamePlayScreen.RouteName: (ctx) => NewGamePlayScreen(),
          CompletedGamesScreen.RouteName: (ctx) => CompletedGamesScreen(),
        },
      ),
    ),
  );
}
