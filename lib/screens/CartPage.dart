import 'package:beklegeliyy/AppLocalizations.dart';
import 'package:beklegeliyy/Constants.dart';
import 'package:beklegeliyy/models/Cart.dart';
import 'package:beklegeliyy/screens/CompleteOrder.dart';
import 'package:beklegeliyy/widgets/MAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:beklegeliyy/data/Database.dart' as db;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  double totalPrice = 0;
  List<Cart> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: MAppBar(title: AppLocalizations.of(context).translate("cartPageTitle")),
      //bottomNavigationBar: buildCartCheck(products),
      body: buildBody(),

    );
  }

  buildBody() {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child("cart")
          .child(auth.currentUser.uid)
          .onValue,
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.snapshot.value != null) {
            snapshot.data.snapshot.value.forEach((key, value) {
              var cart = Cart.fromJson(key, value);
              totalPrice += cart.product.productAmount * cart.product.productPrice;
              products.add(cart);
            });
          }
          if (products.length > 0) {
            return buildListView(products);
          } else {
            return Center(
              child: Text(
                  AppLocalizations.of(context).translate("cartPageTitle"),
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  buildListView(List<Cart> products) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 1.3,
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  return Card(
                    elevation: 3,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            trailing: IconButton(
                              onPressed: () {
                                db.deleteProductFromCart(
                                    auth.currentUser.uid, product.product.productId);
                                setState((){
                                  products.removeAt(index);
                                });

                              },
                              icon: Icon(Icons.delete),
                            ),
                            tileColor: Colors.grey[200],
                            leading: Image.network(product.product.productImgURL,
                                width: 50, height: 50),
                            title: Text(
                              product.product.productName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text(product.product.productAmount.toString() +
                                " x " +
                                product.product.productPrice.toString() +
                                "TL"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        buildCartCheck(products)
      ],
    );
  }

  buildCartCheck(List<Cart> products) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 30,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: AppLocalizations.of(context).translate("cartPageTotal") + " :\n",
                    children: [
                      TextSpan(
                        text: "\₺" + totalPrice.toStringAsFixed(2),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Constants.redAppColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompleteOrder(products)));
                      },
                      child: Text(
                        AppLocalizations.of(context).translate("cartPageButton"),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
