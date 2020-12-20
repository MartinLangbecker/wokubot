import 'package:flutter/material.dart';

class MediaList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('Image $index'),
          subtitle: Text(
              'This is a description of image $index. For example, you could describe the emotions you want to convey when displaying this image.'),
          isThreeLine: true,
          leading: SizedBox(
            height: 120,
            child: Image.asset('images/wokubot_hearts.png'),
          ),
          onTap: () {
            final snackBar = SnackBar(
              content: Text('Tapped on entry $index'),
              duration: Duration(seconds: 2),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          },
        );
      },
    );
  }
}
