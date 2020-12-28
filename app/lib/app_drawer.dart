import 'package:wokubot/login_screen.dart';
import 'package:wokubot/logout_screen.dart';
import 'package:wokubot/settings_screen.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  final bool isConnected;
  final VoidCallback toggleConnectionState;

  const AppDrawer({Key key, this.isConnected, this.toggleConnectionState}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 20)),
          (!widget.isConnected)
              ? ListTile(
                  leading: Icon(Icons.login),
                  title: Text('Connect'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(
                          toggleConnectionState: widget.toggleConnectionState,
                        ),
                      ),
                    );
                  },
                )
              : ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Disconnect'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogoutScreen(
                          toggleConnectionState: widget.toggleConnectionState,
                        ),
                      ),
                    );
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
