import 'package:flutter/material.dart';
import 'login_page.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final avatar = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
        tag: 'logo',
        child: SizedBox(
          height: 160,
          child: Image.asset('../samples/images/wokubot_hearts.png'),
        ),
      ),
    );

    final description = Padding(
      padding: EdgeInsets.all(10),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          text: 'This is a description of a user. This is for test purposes only and will not be needed in the future.',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );

    final buttonLogout = FlatButton(
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Text(
        'Logout',
        style: TextStyle(color: Colors.black87, fontSize: 16),
      ),
    );

    return SafeArea(
        child: Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            avatar,
            description,
            buttonLogout,
          ],
        ),
      ),
    ));
  }
}
