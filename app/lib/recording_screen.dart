import 'package:wokubot/app_drawer.dart';
import 'package:flutter/material.dart';

class RecordingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Voice Recorder'),
        ),
        drawer: AppDrawer(),
        body: Center(
          child: Text('Voice recorder coming soon!™'),
        ),
      ),
    );
  }
}
