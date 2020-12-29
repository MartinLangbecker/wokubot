import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wokubot/app_drawer.dart';
import 'package:wokubot/connection_model.dart';
import 'package:wokubot/database_adapter.dart';
import 'package:wokubot/media_details_screen.dart';
import 'package:wokubot/media_entry.dart';

class MediaList extends StatefulWidget {
  final String type;

  MediaList({Key key, this.type = 'images'}) : super(key: key);

  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  List<MediaEntry> images = const [];
  List<MediaEntry> audio = const [];
  List<MediaEntry> video = const [];

  Future loadMediaList() async {
    DatabaseAdapter.instance.getAllMedia().then((media) {
      setState(() {
        media.forEach((entry) {
          switch (entry.type) {
            case 'image':
              {
                images.add(entry);
              }
              break;
            case 'audio':
              {
                audio.add(entry);
              }
              break;
            case 'video':
              {
                video.add(entry);
              }
              break;
            default:
              {
                print('MediaEntry $entry has unsupported type');
              }
              break;
          }
        });
      });
    }).catchError((error) => print(error));
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
          drawer: AppDrawer(),
          body: TabBarView(
            children: [
              ListView.separated(
                itemCount: images.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (BuildContext context, int index) {
                  MediaEntry entry = images[index];
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaDetailsScreen(entry),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.play_circle_filled,
                        color: Colors.green,
                        size: 50,
                      ),
                      onPressed: () {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: (context.read<ConnectionModel>().isConnected)
                                ? Text('Showing ${entry.name} on server ...')
                                : Text('Preview ${entry.name} locally ...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              ListView.separated(
                itemCount: audio.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (BuildContext context, int index) {
                  MediaEntry entry = audio[index];
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaDetailsScreen(entry),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.play_circle_filled,
                        color: Colors.green,
                        size: 50,
                      ),
                      onPressed: () {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: (context.read<ConnectionModel>().isConnected)
                                ? Text('Showing ${entry.name} on server ...')
                                : Text('Preview ${entry.name} locally ...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              ListView.separated(
                itemCount: video.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (BuildContext context, int index) {
                  MediaEntry entry = video[index];
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaDetailsScreen(entry),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.play_circle_filled,
                        color: Colors.green,
                        size: 50,
                      ),
                      onPressed: () {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: (context.read<ConnectionModel>().isConnected)
                                ? Text('Showing ${entry.name} on server ...')
                                : Text('Preview ${entry.name} locally ...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
