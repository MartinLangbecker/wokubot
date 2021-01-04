import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wokubot/database_adapter.dart';
import 'package:wokubot/media_entry.dart';
import 'package:wokubot/utils/media_utils.dart';
import 'package:wokubot/utils/video_controls_overlay.dart';

class MediaDetailsScreen extends StatefulWidget {
  final MediaEntry entry;

  const MediaDetailsScreen(this.entry);

  @override
  _MediaDetailsScreenState createState() => _MediaDetailsScreenState(entry);
}

class _MediaDetailsScreenState extends State<MediaDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  VideoPlayerController _videoController;
  MediaEntry entry;
  bool _newEntry;
  bool _hasChanged;
  bool _isLocked;

  _MediaDetailsScreenState(MediaEntry entry) {
    _nameController = TextEditingController(text: entry.name);
    _descriptionController = TextEditingController(text: entry.description);
    this.entry = entry.copyWith();
    _newEntry = entry.id == null;
    _hasChanged = _newEntry;
    _isLocked = !_newEntry;
  }

  Future<bool> _onBackPressed(BuildContext context) {
    // TODO if changes were made, ask if user wants to save (Yes/No/Discard)
    return (!_isLocked && _hasChanged)
        ? MediaUtils.showYesNoDialog<bool>(
            context: context,
            title: 'Exit without saving?',
            content: 'Do you want to return without saving changes?',
          )
        : Future<bool>.value(true);
  }

  Future<bool> _onDeletePressed(BuildContext context) {
    return MediaUtils.showYesNoDialog<bool>(
      context: context,
      title: 'Delete entry?',
      content: 'Do you really want to delete this entry from the database?',
    );
  }

  void _saveEntry(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    // FIXME getExternalStorageDirectory() will not work on iOS
    // (see https://pub.dev/documentation/path_provider/latest/path_provider/getExternalStorageDirectory.html)
    final String path = await getExternalStorageDirectory().then((directory) => directory.path);

    if (entry.file == null) entry.file = 'assets/images/placeholder.png';
    final String basename = p.basename(entry.file);

    File file;
    // TODO improve caching (?)
    if (!File('$path/$basename').existsSync()) {
      file = await File(entry.file).copy('$path/$basename');
    } else {
      file = File('$path/$basename');
    }

    setState(() {
      entry.file = file.path;
      _hasChanged = false;
    });

    if (_newEntry) {
      DatabaseAdapter.instance.insertMedia(entry).then((id) {
        setState(() {
          entry.id = id;
          _newEntry = false;
        });
      });
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Entry ${entry.name} saved in database'),
          duration: Duration(seconds: 2),
        ));
    } else {
      DatabaseAdapter.instance.updateMedia(entry);
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Entry ${entry.name} updated in database'),
          duration: Duration(seconds: 2),
        ));
    }
  }

  void _deleteEntry(BuildContext context) {
    _onDeletePressed(context).then((deletionConfirmed) {
      if (deletionConfirmed) {
        DatabaseAdapter.instance.deleteMedia(entry.id);
        setState(() {
          _nameController.clear();
          _descriptionController.clear();
          entry = new MediaEntry();
          _newEntry = true;
          _hasChanged = true;
          _isLocked = false;
        });
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Entry deleted from database'),
            duration: Duration(seconds: 2),
          ));
      }
    });
  }

  void _pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(allowCompression: true);

    if (result != null) {
      setState(() {
        entry.file = result.files.first.path;
        entry.type = MediaUtils.detectFileType(File(result.files.first.path));
        _hasChanged = true;
      });

      if (entry.type != MediaType.IMAGE) _initVideoPlayer();
    }
  }

  Widget _getMedia(MediaEntry entry) {
    switch (entry.type) {
      case MediaType.IMAGE:
        return Image.file(File(entry.file));
        break;
      case MediaType.AUDIO:
        return _videoController.value.initialized
            ? AspectRatio(
                aspectRatio: 3 / 1,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(color: Colors.black87),
                    VideoPlayer(_videoController),
                    VideoControlsOverlay(controller: _videoController),
                    VideoProgressIndicator(_videoController, allowScrubbing: true),
                  ],
                ),
              )
            : Image.asset('assets/images/audio_placeholder.png');
        break;
      case MediaType.VIDEO:
        return _videoController.value.initialized
            ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(color: Colors.black87),
                    VideoPlayer(_videoController),
                    VideoControlsOverlay(controller: _videoController),
                    VideoProgressIndicator(_videoController, allowScrubbing: true),
                  ],
                ),
              )
            : Image.asset('assets/images/video_placeholder.png');
        break;
      default:
        throw new ErrorDescription('File type ${entry.type} is not supported');
    }
  }

  void _initVideoPlayer() {
    _videoController = VideoPlayerController.file(File(entry.file))
      ..addListener(() => setState(() {}))
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void initState() {
    super.initState();
    if (entry.type == MediaType.AUDIO || entry.type == MediaType.VIDEO) _initVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _videoController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context).then((willPop) {
        if (willPop) {
          Navigator.pop(context, entry);
        }
        return Future<bool>.value(false);
      }),
      child: SafeArea(
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
                      _saveEntry(context);
                    }
                  },
                  tooltip: 'Edit media entry',
                );
              }),
              Builder(builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _newEntry ? null : () => _deleteEntry(context),
                  tooltip: 'Delete media entry',
                );
              }),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: GestureDetector(
                    child: Hero(
                      tag: 'hero',
                      child: SizedBox(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Center(
                              child: (entry.file != null)
                                  ? _getMedia(entry)
                                  : Icon(
                                      Icons.add,
                                      size: 64,
                                    ),
                            ),
                            (_isLocked)
                                ? Container()
                                : Align(
                                    alignment: Alignment.lerp(
                                      Alignment.bottomCenter,
                                      Alignment.bottomRight,
                                      0.9,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                    onTap: (_isLocked) ? null : () => _pickFile(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    textAlign: TextAlign.left,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.black87, fontSize: 20),
                    enabled: !_isLocked,
                    onSaved: (name) => setState(() => entry.name = name),
                    onChanged: (text) => setState(() => _hasChanged = (text != entry.name)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    textAlign: TextAlign.left,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(color: Colors.black87, fontSize: 20),
                    enabled: !_isLocked,
                    onSaved: (description) => setState(() => entry.description = description),
                    onChanged: (text) => setState(() => _hasChanged = (text != entry.name)),
                    minLines: 1,
                    maxLines: 5,
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
