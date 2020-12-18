import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
        tag: 'hero',
        child: SizedBox(
          height: 160,
          child: Image.asset('../samples/images/wokubot_main.jpg'),
        ),
      ),
    );

    final description = Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        'In a later version, you will need to enter the server IP in the input field below. For now, just press "Login".\n\nAnd thanks for testing my app! :)',
        style: TextStyle(color: Colors.black87, fontSize: 20),
      ),
    );

    final inputAddress = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Server IP (e. g. 192.168.0.1)',
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
        ),
      ),
    );

    final buttonLogin = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () => {},
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            children: <Widget>[
              logo,
              description,
              inputAddress,
              buttonLogin,
            ],
          ),
        ),
      ),
    );
  }
}
