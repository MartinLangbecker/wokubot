import 'package:wokubot/app_drawer.dart';
import 'package:flutter/material.dart';

class RecordingScreen extends StatefulWidget {
  final bool isConnected;
  final VoidCallback toggleConnectionState;

  const RecordingScreen({Key key, this.isConnected, this.toggleConnectionState}) : super(key: key);

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
        drawer: AppDrawer(
          isConnected: widget.isConnected,
          toggleConnectionState: widget.toggleConnectionState,
        ),
        body: Center(
          child: Text('Voice recorder coming soon!™'),
        ),
      ),
    );
  }
}
