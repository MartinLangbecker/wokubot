import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'main_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController(text: '192.168.0.1'); // TODO remove initial st?
  final _addressValidator = MultiValidator([
    PatternValidator(
        r'\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\b',
        errorText: 'Please enter a valid IP address.'),
    RequiredValidator(errorText: 'Please enter a valid IP address.'),
  ]);
  String address = '';

  void _handleLogin() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      address = _addressController.text;
    });
    if (_connectToServer()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(title: 'Wokubot Home')));
    } else {
      // TODO display error message "Error connecting to server"
    }
  }

  bool _connectToServer() {
    // TODO implement
    return true;
  }

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
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          text:
              'In a later version, you will need to enter the server IP in the input field below. For now, just press "Login".\n\nAnd thanks for testing my app! :)',
          style: TextStyle(color: Colors.black87, fontSize: 20),
        ),
      ),
    );

    final inputAddress = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: _addressController,
        decoration: InputDecoration(
          hintText: 'Server IP (e. g. 192.168.0.1)',
          // contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
        ),
        keyboardType: TextInputType.number,
        onFieldSubmitted: (_) => _handleLogin(),
        onSaved: (text) => address = text,
        textAlign: TextAlign.center,
        validator: _addressValidator,
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
          onPressed: () => _handleLogin(),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
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
      ),
    );
  }
}
