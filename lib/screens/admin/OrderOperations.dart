import 'file:///C:/Users/Batuhan/AndroidStudioProjects/beklegeliyy/lib/models/Order.dart';
import 'package:beklegeliyy/screens/admin/OrderDetailPage.dart';
import 'package:beklegeliyy/widgets/MAppBar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../AppLocalizations.dart';
import '../../Constants.dart';

class OrderOperations extends StatefulWidget {
  @override
  _OrderOperationsState createState() => _OrderOperationsState();
}

class _OrderOperationsState extends State<OrderOperations> {
  final List<Order> orders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title: AppLocalizations.of(context).translate("orderOperationsTitle")),
      body: Column(
        children: [buildOrderStream()],
      ),
    );
  }

  buildOrderStream() {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("orders").onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              snapshot.data.snapshot.value.forEach((key, value) {
                var order = Order.fromJson(key, value);
                print(order.orderId);
                orders.add(order);
              });
              return buildOrderList(orders);
            } else {
              return Center(
                child: Text(
                  AppLocalizations.of(context).translate("productOperationsError"),
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
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderDetailPage(order: order)));
          },
          child: Container(
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
                subtitle: Text(AppLocalizations.of(context).translate("orderOperationsDate") +
                    order.orderDate.toString() +
                    "\n" +
                    AppLocalizations.of(context).translate("orderOperationsPrice") +
                    order.totalPrice.toStringAsFixed(2)),
                isThreeLine: true,
              )),
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
