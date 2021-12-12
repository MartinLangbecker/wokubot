import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart' as p;
import 'package:wokubot/media_entry.dart';
import 'package:wokubot/media_player.dart';

class MediaUtils {
  static MediaType getFileType(File file) {
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
        throw ErrorDescription('File type $extension is not supported');
    }
  }

  static Widget getMedia(MediaEntry entry) {
    switch (entry.type) {
      case MediaType.IMAGE:
        return Image.file(File(entry.file!));
      case MediaType.AUDIO:
        return MediaPlayer(
          file: File(entry.file!),
          aspectRatio: 3 / 1,
          placeholderAsset: 'assets/images/audio_placeholder.png',
        );
      case MediaType.VIDEO:
        return MediaPlayer(
          file: File(entry.file!),
          aspectRatio: null,
          placeholderAsset: 'assets/images/video_placeholder.png',
        );
      default:
        throw ErrorDescription('File type ${entry.type} is not supported');
    }
  }

  static Future<File> writeToFile({
    required ByteData data,
    required String path,
    bool flush = false,
  }) {
    final ByteBuffer buffer = data.buffer;
    List<int> bytes = buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    return File(path).writeAsBytes(bytes, flush: flush);
  }

  static Future<bool?> showYesNoDialog(BuildContext context, {required String title, required String content}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.yes),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.no),
          ),
        ],
      ),
    );
  }

  static Future<String?> showYesNoCancelDialog(BuildContext context, {required String title, required String content}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'yes'),
            child: Text(AppLocalizations.of(context)!.yes),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'no'),
            child: Text(AppLocalizations.of(context)!.no),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: Text(AppLocalizations.of(context)!.cancel),
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.close,
                      style: TextStyle(fontSize: 20),
                    ),
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
