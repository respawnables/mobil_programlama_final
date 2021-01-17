import 'package:beklegeliyy/Constants.dart';
import 'package:beklegeliyy/screens/HomePage.dart';
import 'package:beklegeliyy/screens/admin/AdminHomePage.dart';
import 'package:beklegeliyy/widgets/MTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../AppLocalizations.dart';
import 'courier/Orders.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var email = TextEditingController();
  var password = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/logo.png",
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 10,
                ),
              ),
              Text(
                AppLocalizations.of(context).translate('loginPageTitle'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Constants.redAppColor,
                ),
              ),
              MTextField(
                  label:
                      AppLocalizations.of(context).translate('loginPageHint1'),
                  controller: email),
              MTextField(
                  label:
                      AppLocalizations.of(context).translate('loginPageHint2'),
                  controller: password,
                  obscureText: true),
              buildLoginButton(),
              buildSignupButton(),
            ],
          ),
        ),
      ),
    );
  }

  buildLoginButton() {
    return RaisedButton.icon(
      onPressed: () {
        login();
      },
      icon: Icon(
        Icons.login,
        color: Colors.white,
      ),
      label: Text(
        AppLocalizations.of(context).translate('loginPageSignButton'),
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      color: Constants.redAppColor,
      elevation: 5,
    );
  }

  buildSignupButton() {
    return RaisedButton.icon(
        color: Constants.orangeAppColor,
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
        icon: Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
        label: Text(
          AppLocalizations.of(context).translate('loginPageSignupButton'),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }

  login() async {
    if (email.text == "admin" && password.text == "123456") {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdminHomePage()));
    } else if (email.text == "respawn" && password.text == "123456") {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Orders(email.text)));
    } else if (email.text == "akekec" && password.text == "123456") {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Orders(email.text)));
    } else {
      final User user = (await auth.signInWithEmailAndPassword(
              email: email.text, password: password.text))
          .user;
      if (user != null) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      }
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
