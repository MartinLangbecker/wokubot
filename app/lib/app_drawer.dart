import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wokubot/models/connection_model.dart';
import 'package:wokubot/screens/screens.dart';

class AppDrawer extends StatefulWidget {
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
          Consumer<ConnectionModel>(
            builder: (_, connection, __) {
              return (!connection.isConnected)
                  ? ListTile(
                      leading: Icon(Icons.login),
                      title: Text('Connect'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(),
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
                            builder: (_) => LogoutScreen(),
                          ),
                        );
                      },
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
