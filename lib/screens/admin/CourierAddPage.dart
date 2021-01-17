import 'package:beklegeliyy/models/Courier.dart';
import 'package:beklegeliyy/widgets/MAppBar.dart';
import 'package:beklegeliyy/widgets/MTextField.dart';
import 'package:flutter/material.dart';
import 'package:beklegeliyy/data/Database.dart' as db;

import '../../AppLocalizations.dart';
import '../../Constants.dart';

class CourierAddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title: AppLocalizations.of(context).translate("courierOperationsTitle")),
      body: CourierAddBody(),
    );
  }
}

class CourierAddBody extends StatefulWidget {
  @override
  _CourierAddBodyState createState() => _CourierAddBodyState();
}

class _CourierAddBodyState extends State<CourierAddBody> {
  var courierName = TextEditingController();
  var courierLastName = TextEditingController();
  var courierUsername = TextEditingController();
  var courierPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MTextField(label: AppLocalizations.of(context).translate("courierOperationsAlertDialogHint1"), controller: courierName),
          MTextField(label: AppLocalizations.of(context).translate("courierOperationsAlertDialogHint2"), controller: courierLastName),
          MTextField(label: AppLocalizations.of(context).translate("courierOperationsAlertDialogHint3"), controller: courierUsername),
          MTextField(
              label: AppLocalizations.of(context).translate("courierOperationsAlertDialogHint4"),
              controller: courierPassword,
              obscureText: true),
          Text(AppLocalizations.of(context).translate("courierOperationsAlertDialogWarn"),),
          buildConfirmButton()
        ],
      ),
    );
  }

  buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: RaisedButton(
          elevation: 2,
          onPressed: clickAddButton,
          color: Constants.redAppColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Container(
            alignment: Alignment.center,
            width: 150,
            height: 50,
            child: Text(
              AppLocalizations.of(context).translate("courierOperationsAddButton"),
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }

  buildDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(AppLocalizations.of(context).translate("successAlertDialogTitle")),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      courierName.clear();
                      courierLastName.clear();
                      courierUsername.clear();
                      courierPassword.clear();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context).translate("successAlertDialogButton")))
            ],
          );
        });
  }

  bool validate() {
    bool valid = false;

    if (courierName.text.isEmpty ||
        courierLastName.text.isEmpty ||
        courierUsername.text.isEmpty ||
        courierPassword.text.isEmpty) {
      valid = false;
    } else {
      valid = true;
    }
    return valid;
  }

  clickAddButton() {
    if (validate()) {
      db
          .addCourier(Courier(courierName.text, courierLastName.text,
              courierUsername.text, courierPassword.text))
          .then((value) => {buildDialog()});
    } else {
      final snackBar = SnackBar(
        content: Text("Eksik bilgiler var. Lütfen Tekrar deneyin!"),
        backgroundColor: Constants.redAppColor,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    courierName.dispose();
    courierLastName.dispose();
    courierUsername.dispose();
    courierPassword.dispose();
    super.dispose();
  }
}
