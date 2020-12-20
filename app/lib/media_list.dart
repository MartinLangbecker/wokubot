import 'package:flutter/material.dart';

class MediaList extends StatefulWidget {
  final String type;

  MediaList({Key key, this.type = 'audio'}) : super(key: key);

  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  var entries = const [
    {
      'title': 'First image',
      'subtitle': 'First, Let\'s start off with something simple.',
      'image': 'images/wokubot_main.jpg',
    },
    {
      'title': 'Second image',
      'subtitle': 'Use this for some deep emotions.',
      'image': 'images/wokubot_hearts.png',
    },
    {
      'title': 'Third image',
      'subtitle': 'Hey, didn\'t we already use this one?',
      'image': 'images/wokubot_main.jpg',
    },
    {
      'title': 'Fourth image',
      'subtitle': 'Oh well, never mind. I forgot that this is just a test.',
      'image': 'images/wokubot_hearts.png',
    },
    {
      'title': 'Fifth image',
      'subtitle': 'Here, have some more!',
      'image': 'images/wokubot_main.jpg',
    },
    {
      'title': 'Sixth image',
      'subtitle': 'How about a subtitle with more text? Maybe I could tell you about this one time at band camp ...',
      'image': 'images/wokubot_hearts.png',
    },
    {
      'title': 'Seventh image',
      'subtitle': 'Wow, you chose some *really* creative titles!\n\nThat was sarcastic, by the way.',
      'image': 'images/wokubot_main.jpg',
    },
    {
      'title': 'Image 8',
      'subtitle': '... you bastard!',
      'image': 'images/wokubot_hearts.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        var entry = entries[index];
        return ListTile(
          title: Text(entry['title']),
          subtitle: Text(
            entry['subtitle'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          isThreeLine: true,
          leading: SizedBox(
            height: 120,
            child: Image.asset(entry['image']),
          ),
          onTap: () {
            final snackBar = SnackBar(
              content: Text('Display ${entry["title"]}'),
              duration: Duration(seconds: 2),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          },
        );
      },
    );
  }
}
