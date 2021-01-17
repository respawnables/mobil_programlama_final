import 'dart:collection';

import 'file:///C:/Users/Batuhan/AndroidStudioProjects/beklegeliyy/lib/models/Courier.dart';
import 'file:///C:/Users/Batuhan/AndroidStudioProjects/beklegeliyy/lib/models/Order.dart';
import 'package:beklegeliyy/widgets/MAppBar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:beklegeliyy/data/Database.dart' as db;

import '../../AppLocalizations.dart';
import '../../Constants.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;

  const OrderDetailPage({Key key, this.order}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<Courier> couriers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title: AppLocalizations.of(context).translate("orderDetailTitle")),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20)),
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder(
              builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                if (snapshot.hasData) {
                  HashMap<String, String> user = HashMap();

                  snapshot.data.snapshot.value.forEach((key, value) {
                    user[key] = value;
                  });
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context).translate("orderDetailUserInfo"),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(AppLocalizations.of(context).translate("orderDetailUserName") + user["userName"]),
                      Text(AppLocalizations.of(context).translate("orderDetailUserLastName") + user["userLastName"]),
                      Text(AppLocalizations.of(context).translate("orderDetailUserEmail") + user["userEmail"])
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
              stream: FirebaseDatabase.instance
                  .reference()
                  .child("users")
                  .child(widget.order.userId)
                  .onValue,
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).translate("orderDetailCourierInfo"),
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                  courierStatus(),
                  style: TextStyle(fontSize: 20),
                ),
                RaisedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height / 3,
                            child: StreamBuilder(
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data.snapshot.value != null) {
                                      snapshot.data.snapshot.value
                                          .forEach((key, value) {
                                        var courier =
                                            Courier.fromJson(key, value);
                                        couriers.add(courier);
                                      });
                                    }
                                  }
                                  return buildCourierList();
                                },
                                stream: FirebaseDatabase.instance
                                    .reference()
                                    .child("couriers")
                                    .onValue),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.motorcycle),
                    label: Text(AppLocalizations.of(context).translate("orderDetailButton")))
              ],
            ),
          )
        ],
      ),
    );
  }

  String courierStatus() {
    switch (widget.order.orderStatus) {
      case 0:
        return AppLocalizations.of(context).translate("orderDetailCourierStatus");
        break;
      case 1:
        return "Kurye Durumu : Kurye Yolda";
        break;
      case 2:
        return "Kurye Durumu : Teslim edildi";
    }
  }

  buildCourierList() {
    return ListView.builder(
      itemCount: couriers.length,
      itemBuilder: (context, index) {
        var courier = couriers[index];
        return GestureDetector(
          onTap: () {
            db.addCourierToOrder(widget.order.orderId, courier.courierId).then((value) =>
            {
              Navigator.pop(context)
            });
          },
          child: Card(
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    tileColor: Colors.grey[200],
                    leading: Icon(
                      Icons.motorcycle,
                      color: Constants.redAppColor,
                      size: 30,
                    ),
                    title: Text(
                      courier.courierName + (" ") + courier.courierLastName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(courier.courierUsername),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
