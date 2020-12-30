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
  List<MediaEntry> _images = [];
  List<MediaEntry> _audio = [];
  List<MediaEntry> _video = [];

  void initState() {
    _loadMediaList();
    super.initState();
  }

  Future _loadMediaList() async {
    _emptyLists();

    DatabaseAdapter.instance.getAllMedia().then((media) {
      setState(() {
        media.forEach((entry) {
          switch (entry.type) {
            case 'image':
              {
                _images.add(entry);
              }
              break;
            case 'audio':
              {
                _audio.add(entry);
              }
              break;
            case 'video':
              {
                _video.add(entry);
              }
              break;
            default:
              {
                throw new ErrorDescription('MediaEntry ${entry.id} has unsupported type');
              }
              break;
          }
        });
      });
    }).catchError((error) => print(error));
  }

  void _emptyLists() {
    setState(() {
      _images = [];
      _audio = [];
      _video = [];
    });
  }

  void _deleteAllMedia(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you REALLY want to delete all media from the database?'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.pop(context, false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.pop(context, true),
            child: Text("YES"),
          ),
        ],
      ),
    ).then((deleteConfirmed) {
      if (deleteConfirmed) {
        DatabaseAdapter.instance.deleteAllMedia();
        _emptyLists();
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Deleted all media from database'),
              duration: Duration(seconds: 2),
            ),
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Media List'),
            actions: [
              Builder(builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MediaDetailsScreen(new MediaEntry()),
                    ),
                  ),
                  tooltip: 'Add media entry',
                );
              }),
              // TODO remove button (?)
              Builder(builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () => _deleteAllMedia(context),
                  tooltip: 'Delete all media entries',
                );
              }),
              Builder(builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () async => _loadMediaList(),
                  tooltip: 'Refresh media list',
                );
              }),
            ],
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
                itemCount: _images.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (BuildContext context, int index) {
                  MediaEntry entry = _images[index];
                  return ListTile(
                    leading: SizedBox(
                      height: 120,
                      child: (entry.file != null) ? Image.asset(entry.file) : null,
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
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
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
                itemCount: _audio.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (BuildContext context, int index) {
                  MediaEntry entry = _audio[index];
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
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
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
                itemCount: _video.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (BuildContext context, int index) {
                  MediaEntry entry = _video[index];
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
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
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
