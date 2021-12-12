import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wokubot/media_entry.dart';

class MediaListTile extends StatelessWidget {
  final Function navigateAndUpdateList;
  final Function onPreviewPressed;
  final BuildContext? context;
  final MediaEntry entry;

  Widget? _getLeading() {
    switch (entry.type) {
      case MediaType.IMAGE:
        return (entry.file != null) ? Image.file(File(entry.file!)) : Image.asset('assets/images/placeholder.png');
      case MediaType.AUDIO:
        return Icon(Icons.audiotrack, size: 40);
      case MediaType.VIDEO:
        return Icon(Icons.local_movies, size: 40);
      case null:
        return null;
    }
  }

  // FIXME: possible to remove variable 'context'?
  MediaListTile(
      {required this.navigateAndUpdateList, required this.entry, required this.onPreviewPressed, this.context});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 120,
        child: _getLeading(),
      ),
      title: Text(entry.name ?? ''),
      subtitle: Text(
        entry.description ?? '',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      onTap: () => navigateAndUpdateList(entry),
      trailing: IconButton(
        icon: Icon(
          Icons.play_circle_filled,
          color: Colors.green,
          size: 50,
        ),
        onPressed: () => onPreviewPressed(context, entry),
      ),
    );
  }
}
