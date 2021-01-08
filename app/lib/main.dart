import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wokubot/models/connection_model.dart';
import 'package:wokubot/screens/screens.dart';

void main() {
  runApp(WokubotApp());
}

class WokubotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConnectionModel(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainScreen(),
      ),
    );
  }
}
