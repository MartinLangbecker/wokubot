import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:wokubot/database_adapter.dart';
import 'package:wokubot/media_entry.dart';
import 'package:wokubot/utils/media_utils.dart';

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
  Widget _mediaWidget;
  MediaEntry _entry;
  MediaEntry _savedEntry;
  bool _newEntry;
  bool _hasChanged;
  bool _isLocked;

  _MediaDetailsScreenState(MediaEntry entry) {
    _nameController = TextEditingController(text: entry.name);
    _descriptionController = TextEditingController(text: entry.description);
    _mediaWidget = (entry.file == null) ? Icon(Icons.add, size: 64) : MediaUtils.getMedia(entry);
    this._entry = entry.copyWith();
    this._savedEntry = entry.copyWith();
    _newEntry = entry.id == null;
    _hasChanged = false;
    _isLocked = !_newEntry;
  }

  Future<bool> _onBackPressed(BuildContext context) {
    // TODO if changes were made, ask if user wants to save (Yes/No/Discard)
    return (!_isLocked && _hasChanged)
        ? MediaUtils.showYesNoDialog<bool>(
            context,
            title: 'Exit without saving?',
            content: 'Do you want to return without saving changes?',
          )
        : Future<bool>.value(true);
  }

  Future<bool> _onDeletePressed(BuildContext context) {
    return MediaUtils.showYesNoDialog<bool>(
      context,
      title: 'Delete entry?',
      content: 'Do you really want to delete this entry from the database?',
    );
  }

  void _saveEntry(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    if (_entry.file == null) _entry.file = 'assets/images/placeholder.png';

    // FIXME getExternalStorageDirectory() will not work on iOS
    // (see https://pub.dev/documentation/path_provider/latest/path_provider/getExternalStorageDirectory.html)
    final String path = await getExternalStorageDirectory().then((directory) => directory.path);
    final String basename = p.basename(_entry.file);
    File file;

    if (!File('$path/$basename').existsSync()) {
      bool fromAsset = (basename == 'placeholder.png');
      file = await _copyFile(
        filePath: _entry.file,
        newPath: '$path/$basename',
        fromAsset: fromAsset,
      );
    } else {
      file = File('$path/$basename');
    }

    setState(() {
      _entry.file = file.path;
      _entry.type = MediaUtils.detectFileType(file);
      _savedEntry.file = _entry.file;
      _savedEntry.type = _entry.type;
      _savedEntry.name = _entry.name;
      _savedEntry.description = _entry.description;
      _hasChanged = false;
    });

    if (_newEntry) {
      DatabaseAdapter.instance.insertMedia(_entry).then((id) {
        setState(() {
          _entry.id = id;
          _savedEntry.id = id;
          _newEntry = false;
        });
      });
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Entry ${_entry.name} saved in database'),
          duration: Duration(seconds: 2),
        ));
    } else {
      DatabaseAdapter.instance.updateMedia(_entry);
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Entry ${_entry.name} updated in database'),
          duration: Duration(seconds: 2),
        ));
    }
  }

  Future<File> _copyFile({@required String filePath, @required String newPath, fromAsset = false}) async {
    Future<File> file;
    if (fromAsset) {
      ByteData data = await rootBundle.load(filePath);
      file = MediaUtils.writeToFile(data: data, path: newPath, flush: true);
    } else {
      file = File(filePath).copy(newPath);
    }

    return file;
  }

  void _deleteEntry(BuildContext context) {
    _onDeletePressed(context).then((deletionConfirmed) {
      if (deletionConfirmed) {
        DatabaseAdapter.instance.deleteMedia(_entry.id);
        setState(() {
          _nameController.clear();
          _descriptionController.clear();
          _entry = new MediaEntry();
          _savedEntry = new MediaEntry();
          _newEntry = true;
          _hasChanged = false;
          _isLocked = false;
        });
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Entry deleted from database'),
              duration: Duration(seconds: 2),
            ),
          );
      }
    });
  }

  void _pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(allowCompression: true);

    if (result != null) {
      setState(() {
        _entry.file = result.files.first.path;
        _entry.type = MediaUtils.detectFileType(File(result.files.first.path));
        _mediaWidget = MediaUtils.getMedia(_entry);
        _hasChanged = true;
      });
    }

    // TODO (re)initialize media player
  }

  @override
  void setState(void Function() func) {
    if (mounted) super.setState(func);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context).then((willPop) {
        if (willPop) {
          Navigator.pop(context, _savedEntry);
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
                              child: _mediaWidget,
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
                    onSaved: (name) => setState(() => _entry.name = name),
                    onChanged: (text) => setState(() => _hasChanged = (text != _entry.name)),
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
                    onSaved: (description) => setState(() => _entry.description = description),
                    onChanged: (text) => setState(() => _hasChanged = (text != _entry.name)),
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
