import 'dart:collection';

class Product {
  String productId;
  String productName;
  double productPrice;
  int productAmount;
  String productCategory;
  String productImgURL;

  Product(this.productId, this.productName, this.productPrice,
      this.productAmount, this.productCategory, this.productImgURL);

  Product.withId(this.productId, this.productName, this.productPrice,
      this.productAmount, this.productCategory, this.productImgURL);

  // read data from Firebase
  factory Product.fromJson(dynamic key, dynamic value) {
    return Product.withId(
        key.toString(),
        value["productName"],
        value["productPrice"],
        value["productAmount"],
        value["productCategory"],
        value["productImgUrl"]);
  }

  //send data to Firebase
  HashMap<String, dynamic> toMap() {
    HashMap data = HashMap<String, dynamic>();
    data["productName"] = productName;
    data["productPrice"] = productPrice;
    data["productAmount"] = productAmount;
    data["productImgUrl"] = productImgURL;
    return data;
  }
}
