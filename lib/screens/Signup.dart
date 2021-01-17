import 'package:beklegeliyy/AppLocalizations.dart';
import 'package:beklegeliyy/models/MUser.dart';
import 'package:beklegeliyy/widgets/MTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beklegeliyy/data/Database.dart' as db;

import '../Constants.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {

  var name = TextEditingController();
  var lastName = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var passwordRepeat = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Image.asset("assets/images/logo.png"),
                width: MediaQuery.of(context).size.width / 2,
                padding: EdgeInsets.symmetric(vertical: 50),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  AppLocalizations.of(context).translate("signupPageTitle"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Constants.redAppColor,
                  ),
                ),
              ),
              Form(
                child: Column(
                  children: [
                    MTextField(label: AppLocalizations.of(context).translate("signupPageHint1"), controller: name),
                    MTextField(label: AppLocalizations.of(context).translate("signupPageHint2"), controller: lastName),
                    MTextField(label: AppLocalizations.of(context).translate("signupPageHint3"), controller: email),
                    MTextField(
                        label: AppLocalizations.of(context).translate("signupPageHint4"),
                        controller: password,
                        obscureText: true),
                    MTextField(
                        label: AppLocalizations.of(context).translate("signupPageHint5"),
                        controller: passwordRepeat,
                        obscureText: true),
                  ],
                ),
              ),
              buildSignupButton(),
            ],
          ),
        ),
      ),
    );
  }

  buildSignupButton() {
    return RaisedButton.icon(
      onPressed: register,
      icon: Icon(
        Icons.assignment_turned_in,
        color: Constants.orangeAppColor,
      ),
      label: Text(
        AppLocalizations.of(context).translate("signupPageButton"),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      color: Colors.white,
      elevation: 5,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    );
  }

  register() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
            email: email.text, password: password.text))
        .user;

    db.addUser(MUser(user.uid, name.text, lastName.text, email.text));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    name.dispose();
    lastName.dispose();
    email.dispose();
    password.dispose();
    passwordRepeat.dispose();
    super.dispose();
  }
}
