import 'package:wokubot/login_screen.dart';
import 'package:wokubot/logout_screen.dart';
import 'package:wokubot/settings_screen.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 20)),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Connect'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Disconnect'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => LogoutScreen()));
            },
          ),
          Divider(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
