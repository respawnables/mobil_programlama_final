import 'dart:collection';

import 'package:beklegeliyy/models/Product.dart';

class Cart {

  String id;
  Product product;
  double amount;


  Cart(this.product, this.amount);

  Cart.withId(this.id, this.product, this.amount);

  // read data from Firebase
  factory Cart.fromJson(dynamic key, dynamic value) {
    return Cart.withId(key.toString(), Product.fromJson(key, value), value["amount"]);
  }

  //send data to Firebase
  HashMap<String, dynamic> toMap() {
    HashMap data = HashMap<String, dynamic>();
    data["productName"] = product.productName;
    data["productAmount"] = amount;
    data["productPrice"] = product.productPrice;
    data["productImgUrl"] = product.productImgURL;
    return data;
  }
}
