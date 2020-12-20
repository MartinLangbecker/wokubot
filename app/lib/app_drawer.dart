import 'package:app/login_page.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 20)),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Connect'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
          )
        ],
      ),
    );
  }
}
