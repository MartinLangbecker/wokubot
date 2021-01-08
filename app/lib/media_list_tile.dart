import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wokubot/media_entry.dart';

class MediaListTile extends StatelessWidget {
  final Function navigateAndUpdateList;
  final Function onPreviewPressed;
  final BuildContext context;
  final MediaEntry entry;

  Widget _getLeading() {
    Widget widget;
    switch (entry.type) {
      case MediaType.IMAGE:
        widget = (entry.file != null) ? Image.file(File(entry.file)) : Image.asset('assets/images/placeholder.png');
        break;
      case MediaType.AUDIO:
        widget = Icon(Icons.audiotrack, size: 40);
        break;
      case MediaType.VIDEO:
        widget = Icon(Icons.local_movies, size: 40);
        break;
    }

    return widget;
  }

  MediaListTile({this.navigateAndUpdateList, this.entry, this.onPreviewPressed, this.context});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 120,
        child: _getLeading(),
      ),
      title: Text(entry.name),
      subtitle: Text(
        entry.description,
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
