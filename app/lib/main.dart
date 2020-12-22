import 'package:flutter/material.dart';
import 'package:wokubot/main_screen.dart';

void main() {
  runApp(WokubotApp());
}

class WokubotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}
