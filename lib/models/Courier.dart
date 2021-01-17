import 'dart:collection';

class Courier {
  String courierId;
  String courierName;
  String courierLastName;
  String courierUsername;
  String courierPassword;

  Courier(this.courierName, this.courierLastName, this.courierUsername,
      this.courierPassword);

  Courier.withId(this.courierId, this.courierName, this.courierLastName,
      this.courierUsername, this.courierPassword);

  // read data from Firebase
  factory Courier.fromJson(dynamic key, dynamic value) {
    return Courier.withId(
        key.toString(),
        value["courierName"],
        value["courierLastName"],
        value["courierUsername"],
        value["courierPassword"]);
  }

  // send data to Firebase
  HashMap<String, String> toMap() {
    HashMap data = HashMap<String, String>();
    data["courierName"] = courierName;
    data["courierLastName"] = courierLastName;
    data["courierUsername"] = courierUsername;
    data["courierPassword"] = courierPassword;
    return data;
  }
}
