import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:wokubot/media_entry.dart';

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
        {
          return MediaType.IMAGE;
        }
      case '.3gp':
      case '.aac':
      case '.amr':
      case '.flac':
      case '.m4a':
      case '.mp3':
      case '.ogg':
      case '.ts':
      case '.wav':
        {
          return MediaType.AUDIO;
        }
      case '.mkv':
      case '.mp4':
      case '.webm':
        {
          return MediaType.VIDEO;
        }
      default:
        throw new ErrorDescription('File type $extension is not supported');
    }
  }
}
