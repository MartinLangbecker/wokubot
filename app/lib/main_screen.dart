import 'package:flutter/material.dart';
import 'package:wokubot/media_list.dart';
import 'package:wokubot/recording_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: [
          MediaList(),
          RecordingScreen(),
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
