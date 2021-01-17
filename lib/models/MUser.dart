import 'dart:collection';

class MUser
{
  String userId;
  String userName;
  String userLastName;
  String userEmail;

  MUser(this.userId, this.userName, this.userLastName, this.userEmail);

  // read data from Firebase
  factory MUser.fromJson(dynamic key, dynamic value)
  {
    return MUser(key.toString(), value["userName"], value["userLastName"], value["userEmail"]);
  }

  //send data to Firebase
  HashMap<String, String> toMap() {
    HashMap data = HashMap<String, String>();
    data["userName"]  = userName;
    data["userLastName"]  = userLastName;
    data["userEmail"] = userEmail;
    return data;
  }
}