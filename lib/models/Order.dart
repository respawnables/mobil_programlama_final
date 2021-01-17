import 'dart:collection';

class Order {
  String orderId;
  String userId;
  String courierId;
  HashMap<dynamic, dynamic> cart;
  HashMap<String, double> location;
  double totalPrice;
  String paymentType;
  String orderDate;
  String note;
  int orderStatus;

  Order(
    this.userId,
    this.courierId,
    this.cart,
    this.location,
    this.totalPrice,
    this.paymentType,
    this.orderDate,
    this.note,
    this.orderStatus,
  );

  Order.withId(
      this.orderId,
      this.userId,
      this.courierId,
      this.cart,
      this.location,
      this.totalPrice,
      this.paymentType,
      this.orderDate,
      this.note,
      this.orderStatus);

  factory Order.fromJson(dynamic key, dynamic value) {
    return Order.withId(
        key.toString(),
        value["userId"],
        value["courierId"],
        HashMap<dynamic, dynamic>.from(value),
        value["location"],
        value["totalPrice"],
        value["paymentType"],
        value["orderDate"],
        value["note"],
        value["orderStatus"]);
  }

  HashMap<String, dynamic> toMap() {
    HashMap<String, dynamic> data = HashMap();
    data["userId"] = userId;
    data["courierId"] = courierId;
    data["products"] = cart;
    data["adress"] = location;
    data["totalPrice"] = totalPrice;
    data["paymentType"] = paymentType;
    data["orderDate"] = orderDate;
    data["note"] = note;
    data["orderStatus"] = orderStatus;
    return data;
  }
}
