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
          text:
              'This is just some random text to fill the space. This is for test purposes only and will not be needed in the future.',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );

    return SafeArea(
        child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 20)),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage())),
              )
            ],
          ),
        ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            avatar,
            description,
          ],
        ),
      ),
      ),
    );
  }
}
