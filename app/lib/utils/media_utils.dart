import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:wokubot/media_entry.dart';
import 'package:wokubot/media_player.dart';

class MediaUtils {
  static MediaType detectFileType(File file) {
    final String extension = p.extension(file.path).toLowerCase();
    switch (extension) {
      case '.bmp':
      case '.gif':
      case '.heic':
      case '.heif':
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.webp':
        return MediaType.IMAGE;
      case '.3gp':
      case '.aac':
      case '.amr':
      case '.flac':
      case '.m4a':
      case '.mp3':
      case '.ogg':
      case '.ts':
      case '.wav':
        return MediaType.AUDIO;
      case '.mkv':
      case '.mp4':
      case '.webm':
        return MediaType.VIDEO;
      default:
        throw new ErrorDescription('File type $extension is not supported');
    }
  }

  static Widget getMedia(MediaEntry entry) {
    switch (entry.type) {
      case MediaType.IMAGE:
        return Image.file(File(entry.file));
        break;
      case MediaType.AUDIO:
        return MediaPlayer(
          file: File(entry.file),
          aspectRatio: 3 / 1,
          placeholderAsset: 'assets/images/audio_placeholder.png',
        );
        break;
      case MediaType.VIDEO:
        return MediaPlayer(
          file: File(entry.file),
          aspectRatio: null,
          placeholderAsset: 'assets/images/video_placeholder.png',
        );
        break;
      default:
        throw new ErrorDescription('File type ${entry.type} is not supported');
    }
  }

  static Future<File> writeToFile({ByteData data, String path, bool flush = false}) {
    final ByteBuffer buffer = data.buffer;
    List<int> bytes = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return new File(path).writeAsBytes(bytes, flush: flush);
  }

  static Future<T> showYesNoDialog<T>(BuildContext context, {String title, String content}) {
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

  static Future showMediaPlayerDialog(BuildContext context, MediaEntry entry) {
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: true,
      barrierLabel: 'Media Player Overlay',
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: SizedBox.expand(
                  child: Center(
                    child: getMedia(entry),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox.expand(
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      'Close',
                      style: TextStyle(fontSize: 20),
                    ),
                    textColor: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
