import 'dart:io';
import 'package:beklegeliyy/models/Product.dart';
import 'package:beklegeliyy/widgets/MAppBar.dart';
import 'package:beklegeliyy/widgets/MTextField.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beklegeliyy/data/Database.dart' as db;
import '../../AppLocalizations.dart';
import '../../Constants.dart';
import 'package:image_picker/image_picker.dart';

class ProductAddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title: AppLocalizations.of(context).translate("productOperationsTitle")),
      body: ProductAddBody(),
    );
  }
}

class ProductAddBody extends StatefulWidget {
  @override
  _ProductAddBodyState createState() => _ProductAddBodyState();
}

class _ProductAddBodyState extends State<ProductAddBody> {
  String category = "Meyve-Sebze";
  File _image;
  String _uploadedFileURL;
  bool progress = false;
  List<String> categories = [
    "Meyve-Sebze",
    "Et Ürünleri",
    "Süt-Kahvaltılık",
    "İçecekler",
    "Temizlik Ürünleri"
  ];

  var productId = TextEditingController();
  var productName = TextEditingController();
  var productPrice = TextEditingController();
  var productAmount = TextEditingController();
  var imagePicker = ImagePicker();

  Future<void> pickImage() async {
    await imagePicker.getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = File(image.path);
      });
    });
  }

  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 5,
                child: Center(
                    child: _image == null
                        ? IconButton(
                            icon: Icon(Icons.wb_sunny,
                                size: 40, color: Constants.redAppColor),
                            onPressed: null)
                        : Image.file(_image)),
              ),
              MTextField(label: AppLocalizations.of(context).translate("productOperationsAlertDialogHint1"), controller: productId),
              MTextField(label: AppLocalizations.of(context).translate("productOperationsAlertDialogHint2"), controller: productName),
              MTextField(label: AppLocalizations.of(context).translate("productOperationsAlertDialogHint3"), controller: productAmount),
              MTextField(label: AppLocalizations.of(context).translate("productOperationsAlertDialogHint4"), controller: productPrice),
              buildChooseCategory(),
              buildPictureAddButton(),
              buildConfirmButton()
            ],
          ),
        ),
      ),
    );
  }

  buildPictureAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: FlatButton.icon(
        onPressed: pickImage,
        icon: Icon(
          Icons.camera_alt_rounded,
          size: 30,
        ),
        label: Text(
          AppLocalizations.of(context).translate("productOperationsImageButton"),
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  buildConfirmButton() {
    return RaisedButton(
        elevation: 2,
        onPressed: clickAddButton,
        color: Constants.redAppColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: progress == false
            ? Container(
                alignment: Alignment.center,
                width: 150,
                height: 50,
                child: Text(
                  AppLocalizations.of(context).translate("productOperationsAddButton"),
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.all(10),
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              ));
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

  buildDialog() {
    setState(() {
      progress = false;
    });
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(AppLocalizations.of(context).translate("successAlertDialogTitle")),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      productId.clear();
                      productName.clear();
                      productAmount.clear();
                      productPrice.clear();
                      _image = null;
                      category = null;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context).translate("successAlertDialogButton")))
            ],
          );
        });
  }

  bool validate() {
    bool valid = false;

    if (productId.text.isEmpty ||
    productName.text.isEmpty ||
        productAmount.text.isEmpty ||
        productPrice.text.isEmpty ||
        category.isEmpty ||
        _image == null) {
      valid = false;
    } else {
      valid = true;
    }
    return valid;
  }

  clickAddButton() {
    if (validate()) {
      setState(() {
        progress = true;
      });
      db
          .uploadFile(_image)
          .then((value) => {_uploadedFileURL = value})
          .then((value) => {
                db
                    .addProduct(Product(
                        productId.text,
                        productName.text,
                        double.parse(productPrice.text),
                        int.parse(productAmount.text),
                        category,
                        _uploadedFileURL))
                    .then((value) => {buildDialog()})
              });
    } else {
      final snackBar =
          SnackBar(content: Text(AppLocalizations.of(context).translate("productOperationsAddError")));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    productId.dispose();
    productName.dispose();
    productAmount.dispose();
    productPrice.dispose();
    super.dispose();
  }
}
