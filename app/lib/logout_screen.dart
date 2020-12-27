import 'package:flutter/material.dart';

class LogoutScreen extends StatefulWidget {
  final VoidCallback toggleConnectionState;

  const LogoutScreen({Key key, this.toggleConnectionState}) : super(key: key);

  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  void _handleDisconnect() {
    if (_disconnectFromServer()) {
      widget.toggleConnectionState();
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
          title: Text('Disconnect from server'),
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
                      text:
                          'In a later version, pressing the button below will disconnect you from the server.\nFor now, pressing "Disconnect" has no effect.',
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
                        'Disconnect',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      color: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      onPressed: () {
                        _handleDisconnect();
                      },
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
