import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wokubot/app_drawer.dart';
import 'package:wokubot/connection_model.dart';
import 'package:wokubot/database_adapter.dart';
import 'package:wokubot/media_details_screen.dart';
import 'package:wokubot/media_entry.dart';
import 'package:wokubot/media_utils.dart';

class MediaListScreen extends StatefulWidget {
  final MediaType type;

  MediaListScreen({Key key, this.type = MediaType.IMAGE}) : super(key: key);

  @override
  _MediaListScreenState createState() => _MediaListScreenState();
}

class _MediaListScreenState extends State<MediaListScreen> {
  List<MediaEntry> _images = [];
  List<MediaEntry> _audio = [];
  List<MediaEntry> _video = [];

  void initState() {
    _insertInitialEntries();
    _loadMediaList();
    super.initState();
  }

  Future _loadMediaList() async {
    _emptyLists();
    _reloadMediaLists();
  }

  void _emptyLists() {
    dev.log('Emptying media lists ...', name: 'MediaListScreen');
    setState(() {
      _images = [];
      _audio = [];
      _video = [];
    });
  }

  void _insertInitialEntries() async {
    dev.log('Inserting initial entries into database ...', name: 'MediaListScreen');
    // TODO add all appropriate entries
    final List<String> initialEntries = [
      'images/wokubot_hearts.png',
      'images/wokubot_main.jpg',
      'images/wokubot_sad.jpg',
      'images/wokubot_sings.jpg',
      'images/wokubot_smokes.jpg',
      'audio/freude.mp3',
      'video/freude.mp4',
    ];
    // FIXME getExternalStorageDirectory() will not work on iOS
    // (see https://pub.dev/documentation/path_provider/latest/path_provider/getExternalStorageDirectory.html)
    final String path = await getExternalStorageDirectory().then((directory) => directory.path);
    initialEntries.forEach((element) async {
      final String basename = p.basename(element);
      if (!File('$path/$basename').existsSync()) {
        ByteData data = await rootBundle.load('assets/$element');
        File file = await MediaUtils.writeToFile(data: data, path: '$path/$basename', flush: true);
        DatabaseAdapter.instance.insertMedia(
          new MediaEntry(
            null,
            p.basenameWithoutExtension(file.path),
            p.basenameWithoutExtension(file.path),
            file.path,
            MediaUtils.detectFileType(file),
          ),
        );
      }
    });
  }

  void _reloadMediaLists() {
    DatabaseAdapter.instance.getAllMedia().then((media) {
      dev.log('Reloading media lists ...', name: 'MediaListScreen');
      media.forEach((entry) {
        _addToList(entry);
      });
    }).catchError((error) => print(error));
  }

  void _addToList(MediaEntry entry) {
    if (entry == null) return;

    List<MediaEntry> list = _getList(entry);
    dev.log('Add ${entry.toString()}', name: 'MediaListScreen');
    setState(() => list.add(entry));
  }

  void _updateList(MediaEntry entry) {
    if (entry == null) return;

    List<MediaEntry> list = _getList(entry);
    dev.log('Update ${entry.toString()}', name: 'MediaListScreen');
    setState(() => list[list.indexWhere((element) => element.id == entry.id)] = entry);
  }

  void _removeFromList(MediaEntry entry) {
    if (entry == null) return;

    List<MediaEntry> list = _getList(entry);
    dev.log('Remove ${entry.toString()}', name: 'MediaListScreen');
    setState(() => list.removeWhere((element) => element.id == entry.id));
  }

  List<MediaEntry> _getList(entry) {
    switch (entry.type) {
      case MediaType.IMAGE:
        {
          return _images;
        }
        break;
      case MediaType.AUDIO:
        {
          return _audio;
        }
        break;
      case MediaType.VIDEO:
        {
          return _video;
        }
        break;
      default:
        {
          throw new ErrorDescription('MediaEntry ${entry.id} has unsupported type');
        }
    }
  }

  void _deleteAllMedia(BuildContext context) {
    dev.log('Deleting all media from media lists ...', name: 'MediaListScreen');
    MediaUtils.showYesNoDialog<bool>(
      context: context,
      title: 'Delete all media?',
      content: 'Do you REALLY want to delete all media from the database?',
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

  void _navigateAndUpdateList(MediaEntry entry) async {
    dev.log('Navigating to MediaDetailsScreen ...', name: 'MediaListScreen');
    final MediaEntry result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaDetailsScreen(entry),
      ),
    );

    if (result == null) return;
    if (entry.id == null && result.id != null) {
      _addToList(result);
    } else if (entry.id != null && result.id != null) {
      _updateList(result);
    } else if (entry.id != null && result.id == null) {
      _removeFromList(entry);
    } else {
      return;
    }
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
                  onPressed: () => _navigateAndUpdateList(new MediaEntry()),
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
              // TODO refactor: extract into widget MediaList(List<MediaType>, ...) and/or MediaListModel with ChangeNotifier
              ListView.separated(
                itemCount: _images.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (BuildContext context, int index) {
                  MediaEntry entry = _images[index];
                  return ListTile(
                    leading: SizedBox(
                      height: 120,
                      child: (entry.file != null) ? Image.file(File(entry.file)) : null,
                    ),
                    title: Text(entry.name),
                    subtitle: Text(
                      entry.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                    onTap: () => _navigateAndUpdateList(entry),
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
                      child: Icon(
                        Icons.audiotrack,
                        size: 40,
                      ),
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
                      child: Icon(
                        Icons.local_movies,
                        size: 40,
                      ),
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
