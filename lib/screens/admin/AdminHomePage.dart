import 'package:beklegeliyy/AppLocalizations.dart';
import 'package:beklegeliyy/Constants.dart';
import 'package:beklegeliyy/widgets/MAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CourierOperations.dart';
import 'OrderOperations.dart';
import 'ProductOperations.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: MAppBar(
            title:
                AppLocalizations.of(context).translate('adminHomePageTitle')),
        body: AdminBody());
  }
}

class AdminBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: buildMenu(context));
  }

  buildMenu(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildFlatButton(
          AppLocalizations.of(context).translate('adminHomePageButton1'),
          Icons.shopping_cart,
          "product",
          context,
        ),
        buildFlatButton(
          AppLocalizations.of(context).translate('adminHomePageButton2'),
          Icons.motorcycle,
          "courier",
          context,
        ),
        buildFlatButton(
          AppLocalizations.of(context).translate('adminHomePageButton3'),
          Icons.shopping_bag,
          "order",
          context,
        ),
      ],
    );
  }

  buildFlatButton(
      String name, IconData icon, String pageName, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: FlatButton.icon(
          color: Constants.redAppColor,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () {
            routePages(pageName, context);
          },
          icon: Icon(
            icon,
            size: 40,
            color: Colors.white,
          ),
          label: Text(
            name,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          )),
    );
  }

  routePages(String pageName, BuildContext context) {
    switch (pageName) {
      case "product":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProductOperations()));
        break;
      case "courier":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CourierOperations()));
        break;
      case "order":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OrderOperations()));
        break;
    }
  }
}
