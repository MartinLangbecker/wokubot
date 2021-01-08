import 'package:flutter/material.dart';
import 'package:wokubot/app_drawer.dart';

class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
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
