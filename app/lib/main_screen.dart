import 'package:wokubot/media_list.dart';
import 'package:wokubot/recording_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isConnected = false;
  int _selectedIndex = 0;

  void _toggleConnectionState() {
    setState(() {
      _isConnected = !_isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: [
          MediaList(
            isConnected: _isConnected,
            toggleConnectionState: () => _toggleConnectionState(),
          ),
          RecordingScreen(
            isConnected: _isConnected,
            toggleConnectionState: () => _toggleConnectionState(),
          ),
        ].elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[300],
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.play_arrow,
                color: Colors.green,
              ),
              label: 'Play',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.circle,
                color: Colors.red,
              ),
              label: 'Record',
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
