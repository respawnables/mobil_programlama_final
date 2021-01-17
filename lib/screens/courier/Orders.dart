import 'package:beklegeliyy/AppLocalizations.dart';
import 'package:beklegeliyy/models/Order.dart';
import 'package:beklegeliyy/screens/courier/OrderTrack.dart';
import 'package:beklegeliyy/widgets/MAppBar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {

  final String courierId;


  Orders(this.courierId);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order> orders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title: AppLocalizations.of(context).translate("ordersPageTitle")),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("orders")
            .orderByChild(widget.courierId)
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              snapshot.data.snapshot.value.forEach((key, value) {
                var order = Order.fromJson(key, value);
                orders.add(order);
              });
              return buildOrderList();
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

  buildOrderList() {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (BuildContext context, int index) {
        var order = orders[index];
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderTrack(order)));
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
                title: Text(order.orderId),
                subtitle: Text(AppLocalizations.of(context).translate("orderOperationsDate") +
                    order.orderDate.toString() +
                    "\n" +
                    AppLocalizations.of(context).translate("orderOperationsPrice") +
                    order.totalPrice.toStringAsFixed(2)),
                isThreeLine: true,
                trailing: order.orderStatus == 1
                    ? Icon(Icons.map, size: 40, color: Colors.green)
                    : null),
          ),
        );
      },
    );
  }
}
