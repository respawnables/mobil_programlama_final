import 'dart:collection';

import 'package:beklegeliyy/models/Cart.dart';
import 'package:beklegeliyy/models/Order.dart';
import 'package:beklegeliyy/screens/HomePage.dart';
import 'package:beklegeliyy/widgets/MAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:beklegeliyy/data/Database.dart' as db;
import 'package:intl/intl.dart';

import '../AppLocalizations.dart';
import '../Constants.dart';

class CompleteOrder extends StatefulWidget {
  final List<Cart> products;

  CompleteOrder(this.products);

  @override
  _CompleteOrderState createState() => _CompleteOrderState();
}

class _CompleteOrderState extends State<CompleteOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: MAppBar(title: AppLocalizations.of(context).translate("completeOrderPageTitle")),
      body: CompleteOrderBody(widget.products),
    );
  }
}

class CompleteOrderBody extends StatefulWidget {
  final List<Cart> products;

  CompleteOrderBody(this.products);

  @override
  _CompleteOrderBodyState createState() => _CompleteOrderBodyState();
}

class _CompleteOrderBodyState extends State<CompleteOrderBody> {
  List<bool> _selections = List.generate(2, (index) => false);

  var note = TextEditingController();

  double userLatitude = 0.0;
  double userLongitude = 0.0;
  bool progress = false;
  bool progressConfirmButton = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    widget.products.forEach((element) {
      setState(() {
        totalPrice +=
            element.product.productPrice * element.product.productAmount;
      });
    });
    return totalPrice;
  }

  Future<void> getLocationInfo() async {
    var location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLatitude = location.latitude;
      userLongitude = location.longitude;
    });

    setState(() {
      progress = true;
    });
  }

  HashMap<String, dynamic> listToMap() {
    HashMap<String, dynamic> data = HashMap();
    widget.products.forEach((element) {
      data[element.product.productId] = element.toMap();
    });

    return data;
  }

  String getPaymentType() {
    String paymentType;
    if (_selections[0] == true) {
      paymentType = "creditCard";
    } else if (_selections[1] == true) {
      paymentType = "cash";
    }
    return paymentType;
  }

  Future<void> completeOrder() async {
    DateTime now = DateTime.now();
    String date = DateFormat('kk:mm - yyyy.MM.dd').format(now);

    HashMap<String, double> locations = HashMap();
    locations["latitude"] = userLatitude;
    locations["longitude"] = userLongitude;

    db.addOrder(Order(auth.currentUser.uid, "null", listToMap(), locations,
        calculateTotalPrice(), getPaymentType(), date, note.text, 0));
  }

  clickConfirmButton() {
    setState(() {
      progressConfirmButton = true;
    });

    completeOrder().then((value) => {buildDialog()});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildPriceContainer(),
          buildAdressContainer(),
          buildPaymentTypeContainer(),
          buildNoteContainer(),
          buildConfirmButton(),
        ],
      ),
    );
  }

  buildPriceContainer() {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context).translate("completeOrderPagePrice"),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "\₺" + calculateTotalPrice().toStringAsFixed(2),
            style: TextStyle(
                fontSize: 20,
                color: Constants.redAppColor,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  buildAdressContainer() {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context).translate("completeOrderPageAdress"),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          RaisedButton.icon(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              getLocationInfo();
            },
            icon: progress
                ? Icon(
                    Icons.download_done_outlined,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.add_location,
                    color: Colors.white,
                  ),
            label: Text(
              AppLocalizations.of(context).translate( "completeOrderPageAdressButton"),
              style: TextStyle(color: Colors.white),
            ),
            color: Constants.redAppColor,
          )
        ],
      ),
    );
  }

  buildPaymentTypeContainer() {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context).translate("completeOrderPagePay"),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ToggleButtons(
            renderBorder: false,
            selectedColor: Constants.redAppColor,
            fillColor: Colors.white,
            children: [
              Icon(Icons.credit_card_rounded),
              Icon(Icons.money_rounded),
            ],
            isSelected: _selections,
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < _selections.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    _selections[buttonIndex] = true;
                  } else {
                    _selections[buttonIndex] = false;
                  }
                }
              });
            },
          )
        ],
      ),
    );
  }

  buildNoteContainer() {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context).translate("completeOrderPageNote"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          TextField(
            controller: note,
            minLines: 5,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).translate("completeOrderPageNote1"),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            cursorColor: Constants.redAppColor,
          )
        ],
      ),
    );
  }

  buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 15,
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Constants.redAppColor,
          onPressed: () {
            clickConfirmButton();
          },
          child: progressConfirmButton
              ? CircularProgressIndicator()
              : Text(
            AppLocalizations.of(context).translate("completeOrderPageButton"),
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  buildDialog() {
    setState(() {
      progressConfirmButton = false;
    });
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
                      note.clear();
                    });
                    db.clearCart(auth.currentUser.uid).then((value) => {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()))
                        });
                  },
                  child: Text(AppLocalizations.of(context).translate("successAlertDialogButton")))
            ],
          );
        });
  }

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }
}
