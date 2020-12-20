import 'package:app/app_drawer.dart';
import 'package:app/media_list.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final String title;

  const MainScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Images',
                  icon: Icon(Icons.image),
                ),
                Tab(
                  text: 'Audio',
                  icon: Icon(Icons.audiotrack),
                ),
                Tab(
                  text: 'Video',
                  icon: Icon(Icons.local_movies),
                )
              ],
            ),
          ),
          drawer: AppDrawer(),
          body: TabBarView(
            children: [
              MediaList(type: 'image'),
              Container(
                child: Center(
                  child: Text('Audio coming soon!™'),
                ),
              ),
              Container(
                child: Center(
                  child: Text('Video coming soon!™'),
                ),
              ),
            ],
          ),
        ),
        length: 3,
      ),
    );
  }
}
