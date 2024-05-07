import 'package:flutter/material.dart';

class RandomAI extends StatelessWidget {
  static String RouteName = "RandomAI";

  const RandomAI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Text("Random AI"),
      ),
    );
  }
}
