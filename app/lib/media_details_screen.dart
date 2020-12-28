import 'package:flutter/material.dart';
import 'package:wokubot/media_entry.dart';

class MediaDetailsScreen extends StatefulWidget {
  MediaDetailsScreen(MediaEntry entry);

  @override
  _MediaDetailsScreenState createState() => _MediaDetailsScreenState();
}

class _MediaDetailsScreenState extends State<MediaDetailsScreen> {
  bool _isLocked = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detail View'),
          actions: [
            IconButton(
              icon: (_isLocked) ? Icon(Icons.edit) : Icon(Icons.save_alt),
              onPressed: () {
                setState(() {
                  _isLocked = !_isLocked;
                });
              },
              tooltip: 'Edit media entry',
            ),
          ],
        ),
        body: null,
      ),
    );
  }
}
