import 'package:beklegeliyy/AppLocalizations.dart';
import 'package:beklegeliyy/models/Cart.dart';
import 'package:beklegeliyy/models/Product.dart';
import 'package:beklegeliyy/widgets/MAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:beklegeliyy/data/Database.dart' as db;
import '../Constants.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  double currentSliderValue = 1;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String category = "Meyve-Sebze";

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      appBar: MAppBar(title: AppLocalizations.of(context).translate("allProductPageTitle")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTopCategories(),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child("products")
                  .child(category)
                  .onValue,
              builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.snapshot.value != null) {
                    List<Product> products = [];
                    snapshot.data.snapshot.value.forEach((key, value) {
                      var courier = Product.fromJson(key, value);
                      products.add(courier);
                    });
                    return buildProductList(products);
                  } else {
                    return Center(
                      child: Text(
                          AppLocalizations.of(context).translate("productOperationsError"),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
    );
  }

  buildTopCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        buildButtons("Meyve-Sebze", 'assets/images/portakal.jpg'),
        buildButtons("Et Ürünleri", 'assets/images/et.jpg'),
        buildButtons("Süt-Kahvaltılık", 'assets/images/yumurta.jpg'),
        buildButtons("İçecekler", 'assets/images/icecek.jpg'),
        buildButtons("Temizlik Ürünleri", 'assets/images/deterjan.jpg'),
      ]),
    );
  }

  buildButtons(String categoryy, String image) {
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      color: Colors.grey[200],
      onPressed: () {
        setState(() {
          category = categoryy;
        });
      },
      child: Column(
        children: [
          CircleAvatar(backgroundImage: AssetImage(image), radius: 30),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(categoryy,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  buildProductList(List<Product> products) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: products.length,
      padding: EdgeInsets.all(2.0),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            print(products[index].productName);
          },
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Container(
              width: (MediaQuery.of(context).size.width) / 2 - 15,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                image: DecorationImage(
                  image: NetworkImage(products[index].productImgURL),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    gradient: new LinearGradient(
                        colors: [
                          Colors.black,
                          const Color(0x19000000),
                        ],
                        begin: const FractionalOffset(0.0, 1.0),
                        end: const FractionalOffset(0.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index].productName,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                products[index].productAmount.toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              Text(
                                '${products[index].productPrice} ₺',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add_shopping_cart_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              addCart(products[index]);
                            },
                          )
                        ],
                      )),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  addCart(Product product) {
    showDialog(
      context: context,
      child: StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).translate("allProductPageAddCart")),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  onChanged: (double value) {
                    setState(() {
                      currentSliderValue = value;
                    });
                  },
                  value: currentSliderValue,
                  min: 1.0,
                  max: 10.0,
                  divisions: 9,
                  label: currentSliderValue.round().toString(),
                  activeColor: Constants.redAppColor,
                  inactiveColor: Constants.orangeAppColor,
                ),
                RaisedButton.icon(
                    color: Colors.white70,
                    onPressed: () {
                      db.addProductToCart(auth.currentUser.uid,
                          Cart(product, currentSliderValue));
                      Navigator.pop(context);
                      final snackBar =
                          SnackBar(content: Text(AppLocalizations.of(context).translate("allProductPageSnackbar")));
                      globalKey.currentState.showSnackBar(snackBar);
                    },
                    icon: Icon(Icons.add_shopping_cart_rounded),
                    label: Text(AppLocalizations.of(context).translate("allProductPageAddCart")))
              ],
            ),
          );
        },
      ),
    );
  }

}
