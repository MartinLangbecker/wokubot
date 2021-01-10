import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wokubot/models/connection_model.dart';

class LogoutScreen extends StatelessWidget {
  void _handleDisconnect(BuildContext context) {
    if (_disconnectFromServer()) {
      context.read<ConnectionModel>().setConnectionState(false);
      Navigator.pop(context);
    }
  }

  bool _disconnectFromServer() {
    // TODO implement
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).logoutScreenAppBar),
        ),
        body: Center(
          child: Form(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Hero(
                    tag: 'hero',
                    child: SizedBox(
                      height: 160,
                      child: Image.asset('assets/images/wokubot_sad.jpg'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: AppLocalizations.of(context).logoutScreenDescription,
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: ButtonTheme(
                    height: 56,
                    child: RaisedButton(
                      child: Text(
                        AppLocalizations.of(context).disconnect,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      color: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      onPressed: () => _handleDisconnect(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
