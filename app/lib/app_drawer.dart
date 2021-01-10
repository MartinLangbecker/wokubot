import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                  // TODO unify login and logout screens
                  ? ListTile(
                      leading: Icon(Icons.login),
                      title: Text(AppLocalizations.of(context).connect),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(context: context),
                          ),
                        );
                      },
                    )
                  : ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(AppLocalizations.of(context).disconnect),
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
                title: Text(AppLocalizations.of(context).settings),
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
