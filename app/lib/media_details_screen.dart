import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:wokubot/database_adapter.dart';
import 'package:wokubot/media_entry.dart';
import 'package:wokubot/media_utils.dart';

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
  MediaEntry entry;
  bool _newEntry;
  bool _isLocked;

  _MediaDetailsScreenState(MediaEntry entry) {
    _nameController = TextEditingController(text: entry.name);
    _descriptionController = TextEditingController(text: entry.description);
    this.entry = entry.copyWith();
    _newEntry = entry.id == null;
    _isLocked = !_newEntry;
  }

  // TODO extract method to utility class
  Future<T> _showYesNoDialog<T>({BuildContext context, String title, String content}) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("No"),
          ),
          new FlatButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) {
    // TODO don't show dialogue if no changes were made
    // TODO if changes were made, ask if user wants to save (Yes/No/Discard)
    return (!_isLocked)
        ? _showYesNoDialog(
            context: context,
            title: 'Exit without saving?',
            content: 'Do you want to return without saving changes?',
          )
        : Future<bool>.value(true);
  }

  Future<bool> _onDeletePressed(BuildContext context) {
    return _showYesNoDialog(
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
    });

    if (_newEntry) {
      DatabaseAdapter.instance.insertMedia(entry).then((id) {
        setState(() {
          entry.id = id;
        });
      });
      _newEntry = false;
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

  void _selectImage() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (pickedFile != null) {
      setState(() {
        entry.file = pickedFile.path;
        entry.type = MediaUtils.detectFileType(File(pickedFile.path));
      });
    }
  }

  // TODO replace placeholder images once video/audio player is implemented
  Image _getImage(MediaEntry entry) {
    switch (entry.type) {
      case MediaType.IMAGE:
        return Image.file(File(entry.file));
        break;
      case MediaType.AUDIO:
        return Image.asset('assets/images/audio_placeholder.png');
        break;
      case MediaType.VIDEO:
        return Image.asset('assets/images/video_placeholder.png');
        break;
      default:
        throw new ErrorDescription('File type ${entry.type} is not supported');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
                        height: 300,
                        child: (entry.file != null)
                            ? _getImage(entry)
                            : Icon(
                                Icons.add,
                                size: 64,
                              ),
                      ),
                    ),
                    onTap: (_isLocked) ? null : () => _selectImage(),
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
