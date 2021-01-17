import 'package:beklegeliyy/AppLocalizations.dart';
import 'package:beklegeliyy/Constants.dart';
import 'package:beklegeliyy/models/Order.dart';
import 'package:beklegeliyy/screens/Login.dart';
import 'package:beklegeliyy/widgets/MAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Order> orders = [];
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
          title: AppLocalizations.of(context).translate("profilePageTitle")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildProfileInfo(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Text(
                AppLocalizations.of(context).translate("profilePageOrder"),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          buildOrderStream()
        ],
      ),
    );
  }

  buildProfileInfo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 6,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_circle, size: 75, color: Colors.lightBlue),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                auth.currentUser.email,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              RaisedButton.icon(
                color: Colors.lightBlue,
                onPressed: () {
                  auth.signOut().then((value) => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()))
                      });
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text(
                  AppLocalizations.of(context).translate("profilePageButton"),
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  buildOrderStream() {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("orders")
            .orderByChild(auth.currentUser.uid)
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              snapshot.data.snapshot.value.forEach((key, value) {
                var order = Order.fromJson(key, value);
                orders.add(order);
              });
              return buildOrderList(orders);
            } else {
              return Center(
                child: Text(
                  AppLocalizations.of(context)
                      .translate("productOperationsError"),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  buildOrderList(List<Order> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (BuildContext context, int index) {
        var order = orders[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: statusIcon(order.orderStatus),
              title: Text(order.orderId),
              subtitle: Text(AppLocalizations.of(context)
                      .translate("orderOperationsDate") +
                  order.orderDate.toString() +
                  "\n" +
                  AppLocalizations.of(context)
                      .translate("orderOperationsPrice") +
                  order.totalPrice.toStringAsFixed(2)),
              isThreeLine: true,
              trailing: order.orderStatus == 1
                  ? Icon(Icons.map, size: 40, color: Colors.green)
                  : null),
        );
      },
    );
  }

  Icon statusIcon(int orderStatus) {
    switch (orderStatus) {
      case 0:
        return Icon(Icons.watch_later_rounded,
            size: 50, color: Constants.orangeAppColor);
        break;
      case 1:
        return Icon(Icons.motorcycle,
            size: 50, color: Constants.orangeAppColor);
        break;
      case 2:
        return Icon(Icons.done, size: 50, color: Constants.orangeAppColor);
        break;
    }
  }
}
