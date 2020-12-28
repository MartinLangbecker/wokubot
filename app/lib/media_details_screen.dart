import 'package:flutter/material.dart';
import 'package:wokubot/media_entry.dart';

class MediaDetailsScreen extends StatefulWidget {
  final MediaEntry entry;

  const MediaDetailsScreen(this.entry);

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
            Builder(builder: (BuildContext context) {
              return IconButton(
                icon: (_isLocked) ? Icon(Icons.edit) : Icon(Icons.save_alt),
                onPressed: () {
                  setState(() {
                    _isLocked = !_isLocked;
                  });
                  if (_isLocked) {
                    // TODO implement saving entry
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('TODO: actually save entry'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                tooltip: 'Edit media entry',
              );
            }),
          ],
        ),
        body: Center(
          child: Form(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Hero(
                    tag: 'hero',
                    child: SizedBox(
                      height: 200,
                      child: Image.asset(widget.entry.file),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    initialValue: widget.entry.name,
                    style: TextStyle(color: Colors.black87, fontSize: 20),
                    enabled: !_isLocked,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    textAlign: TextAlign.justify,
                    initialValue: widget.entry.description,
                    style: TextStyle(color: Colors.black87, fontSize: 20),
                    enabled: !_isLocked,
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
