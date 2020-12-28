import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:wokubot/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:wokubot/media_details_screen.dart';
import 'package:wokubot/media_entry.dart';

class MediaList extends StatefulWidget {
  final bool isConnected;
  final VoidCallback toggleConnectionState;
  final String type;

  MediaList({Key key, this.type = 'audio', this.isConnected, this.toggleConnectionState}) : super(key: key);

  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  List<MediaEntry> entries = const [];

  Future loadMediaList() async {
    String content = await rootBundle.loadString('data/media_entries.json');
    List collection = json.decode(content);
    List<MediaEntry> _entries = collection.map((json) => MediaEntry.fromJson(json)).toList();

    setState(() {
      entries = _entries;
    });
  }

  void initState() {
    loadMediaList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Media List'),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Images',
                  icon: Icon(Icons.image),
                ),
                Tab(
                  text: 'Audio',
                  icon: Icon(Icons.audiotrack),
                ),
                Tab(
                  text: 'Video',
                  icon: Icon(Icons.local_movies),
                )
              ],
            ),
          ),
          drawer: AppDrawer(
            isConnected: widget.isConnected,
            toggleConnectionState: widget.toggleConnectionState,
          ),
          body: TabBarView(
            children: [
              ListView.separated(
                itemCount: entries.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (BuildContext context, int index) {
                  MediaEntry entry = entries[index];
                  return ListTile(
                    leading: SizedBox(
                      height: 120,
                      child: Image.asset(entry.file),
                    ),
                    title: Text(entry.name),
                    subtitle: Text(
                      entry.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MediaDetailsScreen(entry))),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.play_circle_filled,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Preview ${entry.name}'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              Container(
                child: Center(
                  child: Text('Audio coming soon!™'),
                ),
              ),
              Container(
                child: Center(
                  child: Text('Video coming soon!™'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
