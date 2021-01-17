import 'dart:collection';

import 'package:beklegeliyy/models/Cart.dart';
import 'package:beklegeliyy/models/Courier.dart';
import 'package:beklegeliyy/models/MUser.dart';
import 'package:beklegeliyy/models/Order.dart';
import 'package:beklegeliyy/models/Product.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();
final productTable = "products";
final courierTable = "couriers";
final userTable = "users";
final cartTable = "cart";
final orderTable = "orders";

/*
*
*  Product Functions
*
*/

Future<void> addProduct(Product product) async {
  await databaseReference
      .child(productTable)
      .child(product.productCategory)
      .child(product.productId)
      .set(product.toMap());
}

Future<void> deleteProduct(Product product) async {
  await databaseReference
      .child(productTable)
      .child(product.productCategory)
      .child(product.productId)
      .remove();
}

Future<void> updateProduct(Product product) async {
  await databaseReference
      .child(productTable)
      .child(product.productCategory)
      .child(product.productId)
      .update(product.toMap());
}

Future<String> uploadFile(File file) async {
  Reference reference = FirebaseStorage.instance
      .ref()
      .child('uploads/${path.basename(file.path)}');

  await reference.putFile(file);
  return await reference.getDownloadURL();
}

/*
*
*  Courier Functions
*
*/

Future<void> addCourier(Courier courier) async {
  await databaseReference
      .child(courierTable)
      .child(courier.courierUsername)
      .set(courier.toMap());
}

Future<void> deleteCourier(Courier courier) async {
  await databaseReference.child(courierTable).child(courier.courierId).remove();
}

Future<void> updateCourier(Courier courier) async {
  await databaseReference
      .child(courierTable)
      .child(courier.courierId)
      .update(courier.toMap());
}

/*
*
*  User Functions
*
*/

Future<void> addUser(MUser user) async {
  await databaseReference.child(userTable).child(user.userId).set(user.toMap());
}

/*
*
*  Cart Functions
*
*/

Future<void> addProductToCart(String uid, Cart cart) async {
  await databaseReference
      .child(cartTable)
      .child(uid)
      .child(cart.product.productId)
      .set(cart.toMap());
}

Future<void> deleteProductFromCart(String uid, String productId) async {
  await databaseReference.child(cartTable).child(uid).child(productId).remove();
}

Future<void> clearCart(String uid) async {
  await databaseReference.child(cartTable).child(uid).remove();
}

/*
*
*  Order Functions
*
*/

Future<void> addOrder(Order order) async {
  await databaseReference.child(orderTable).push().set(order.toMap());
}


Future<void> addCourierToOrder(String orderId, String courierId) async {
  await databaseReference
      .child(orderTable)
      .child(orderId)
      .update({"courierId": courierId});
}

