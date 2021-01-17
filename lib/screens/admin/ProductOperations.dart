import 'dart:io';

import 'package:beklegeliyy/AppLocalizations.dart';
import 'package:beklegeliyy/widgets/MAppBar.dart';
import 'package:beklegeliyy/widgets/MTextField.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import '../../Constants.dart';
import 'package:beklegeliyy/models/Product.dart';
import 'ProductAddPage.dart';
import 'package:beklegeliyy/data/Database.dart' as db;

class ProductOperations extends StatefulWidget {
  @override
  _ProductOperationsState createState() => _ProductOperationsState();
}

class _ProductOperationsState extends State<ProductOperations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title: AppLocalizations.of(context).translate("productOperationsTitle")),
      body: ProductBody(),
      floatingActionButton: _buildFAB(context),
    );
  }

  _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProductAddPage()));
      },
      backgroundColor: Constants.redAppColor,
      elevation: 2,
      child: Icon(Icons.add),
    );
  }
}

class ProductBody extends StatefulWidget {
  @override
  _ProductBodyState createState() => _ProductBodyState();
}

class _ProductBodyState extends State<ProductBody> {
  String uploadedFileUrl;
  File _imageFile;
  String category = "Meyve-Sebze";
  List<String> categories = [
    "Meyve-Sebze",
    "Et Ürünleri",
    "Süt-Kahvaltılık",
    "İçecekler",
    "Temizlik Ürünleri"
  ];
  var productName = TextEditingController();
  var productAmount = TextEditingController();
  var productPrice = TextEditingController();
  var imagePicker = ImagePicker();

  Future<File> pickImage() async {
    await imagePicker.getImage(source: ImageSource.gallery).then((image) {
      _imageFile = File(image.path);
    });
    return _imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildChooseCategory(),
        Expanded(
            child: StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child("products")
              .child(category)
              .onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasData) {
              List<Product> products = [];
              if (snapshot.data.snapshot.value != null) {
                snapshot.data.snapshot.value.forEach((key, value) {
                  var product = Product.fromJson(key, value);
                  products.add(product);
                });
              }
              if (products.length > 0) {
                return buildGridView(products);
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
        ))
      ],
    );
  }

  buildGridView(List<Product> products) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: products.length,
      padding: EdgeInsets.all(2.0),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            buildOptionMenu(products[index]);
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
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
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  buildOptionMenu(Product product) {
    showModalBottomSheet(
        isDismissible: true,
        context: context,
        builder: (ctx) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlatButton.icon(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      db
                          .deleteProduct(Product.withId(
                              product.productId,
                              productName.text,
                              double.tryParse(productPrice.text),
                              int.tryParse(productAmount.text),
                              category,
                              uploadedFileUrl))
                          .then((value) => {Navigator.pop(context)});
                    },
                    label: Text(
                      AppLocalizations.of(context).translate("productOperationsDelete"),
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.end,
                    ),
                    height: MediaQuery.of(context).size.height * 0.1,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.update),
                    onPressed: () {
                      setState(() {
                        productName.text = product.productName;
                        productAmount.text = product.productAmount.toString();
                        productPrice.text = product.productPrice.toString();
                      });
                      buildAlertDialog(product);
                    },
                    label: Text(
                      AppLocalizations.of(context).translate("productOperationsUpdate"),
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.end,
                    ),
                    height: MediaQuery.of(context).size.height * 0.1,
                    minWidth: MediaQuery.of(context).size.width,
                  )
                ],
              ));
        });
  }

  buildAlertDialog(Product product) {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text(AppLocalizations.of(context).translate("productOperationsAlertDialogTitle")),
        content: StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _imageFile == null
                      ? Image.network(
                          product.productImgURL,
                          height: 100,
                          width: 100,
                        )
                      : Image.file(
                          _imageFile,
                          height: 100,
                          width: 100,
                        ),
                  MTextField(label: AppLocalizations.of(context).translate("productOperationsAlertDialogHint2"), controller: productName),
                  MTextField(label: AppLocalizations.of(context).translate("productOperationsAlertDialogHint3"), controller: productAmount),
                  MTextField(label: AppLocalizations.of(context).translate("productOperationsAlertDialogHint4"), controller: productPrice),
                  FlatButton.icon(
                      onPressed: () {
                        pickImage().then((value) => {
                              setState(() {
                                _imageFile = value;
                              })
                            });
                      },
                      icon: Icon(Icons.camera_alt_rounded),
                      label: Text(AppLocalizations.of(context).translate("productOperationsAlertDialogImageButton"))),
                  Text(AppLocalizations.of(context).translate("productOperationsAlertDialogWarn")),
                ],
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 10),
            child: TextButton(
              onPressed: () {
                clickUpdateButton(product);
              },
              child: Text(
                AppLocalizations.of(context).translate("productOperationsAlertDialogImageButton"),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildChooseCategory() {
    return DropdownButton<String>(
      value: category,
      hint: Text(AppLocalizations.of(context).translate("productOperationsChooseCategory")),
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        width: 100,
        height: 2,
        color: Constants.redAppColor,
      ),
      onChanged: (String newValue) {
        setState(() {
          category = newValue;
          print(category);
        });
      },
      items: categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  clickUpdateButton(Product product) {
    if (validate()) {
      db
          .uploadFile(_imageFile)
          .then((value) => {uploadedFileUrl = value})
          .then((value) => {
                db
                    .updateProduct(Product.withId(
                        product.productId,
                        productName.text,
                        double.tryParse(productPrice.text),
                        int.tryParse(productAmount.text),
                        category,
                        uploadedFileUrl))
                    .then((value) =>
                        {Navigator.pop(context), Navigator.pop(context)})
              });
    }
  }

  bool validate() {
    bool valid = false;

    if (productName.text.isEmpty ||
        productAmount.text.isEmpty ||
        productPrice.text.isEmpty ||
        category.isEmpty ||
        _imageFile == null) {
      valid = false;
    } else {
      valid = true;
    }
    return valid;
  }

  @override
  void dispose() {
    productName.dispose();
    productAmount.dispose();
    productPrice.dispose();
    super.dispose();
  }
}
