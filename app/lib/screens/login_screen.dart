import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:wokubot/models/connection_model.dart';

class LoginScreen extends StatefulWidget {
  final BuildContext context;

  const LoginScreen({Key key, this.context}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState(context);
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController(text: '192.168.0.1');
  final String _addressPattern =
      r'\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\b';
  MultiValidator _addressValidator;
  String address = '';

  _LoginScreenState(BuildContext context) {
    _addressValidator = MultiValidator([
      PatternValidator(_addressPattern, errorText: AppLocalizations.of(context).loginScreenAddressValidatorError),
      RequiredValidator(errorText: AppLocalizations.of(context).loginScreenAddressValidatorError),
    ]);
  }

  void _handleConnect(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      address = _addressController.text;
    });
    if (_connectToServer()) {
      context.read<ConnectionModel>().setConnectionState(true);
      Navigator.pop(context);
    } else {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).loginScreenConnectionError),
          duration: Duration(seconds: 2),
        ));
    }
  }

  bool _connectToServer() {
    // TODO #33 implement
    return true;
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).loginScreenAppBar),
        ),
        body: Center(
          child: Form(
            key: _formKey,
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
                      child: Image.asset('assets/images/wokubot_main.jpg'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: AppLocalizations.of(context).loginScreenDescription,
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Builder(builder: (BuildContext context) {
                    return TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).loginScreenAddressHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) => _handleConnect(context),
                      onSaved: (text) => address = text,
                      textAlign: TextAlign.center,
                      validator: _addressValidator,
                    );
                  }),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: ButtonTheme(
                    height: 56,
                    child: Builder(builder: (BuildContext context) {
                      return RaisedButton(
                        child: Text(
                          AppLocalizations.of(context).connect,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        color: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onPressed: () => _handleConnect(context),
                      );
                    }),
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
