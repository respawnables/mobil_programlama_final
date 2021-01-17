import 'package:beklegeliyy/models/Courier.dart';
import 'package:beklegeliyy/screens/admin/CourierAddPage.dart';
import 'package:beklegeliyy/widgets/MAppBar.dart';
import 'package:beklegeliyy/widgets/MTextField.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:beklegeliyy/data/Database.dart' as db;
import '../../AppLocalizations.dart';
import '../../Constants.dart';

class CourierOperations extends StatefulWidget {
  @override
  _CourierOperationsState createState() => _CourierOperationsState();
}

class _CourierOperationsState extends State<CourierOperations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
          title:
              AppLocalizations.of(context).translate("courierOperationsTitle")),
      body: CourierBody(),
      floatingActionButton: _buildFAB(context),
    );
  }

  _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CourierAddPage()));
      },
      backgroundColor: Constants.redAppColor,
      elevation: 2,
      child: Icon(Icons.add),
    );
  }
}

class CourierBody extends StatefulWidget {
  @override
  _CourierBodyState createState() => _CourierBodyState();
}

class _CourierBodyState extends State<CourierBody> {
  var courierName = TextEditingController();
  var courierLastName = TextEditingController();
  var courierUsername = TextEditingController();
  var courierPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.reference().child("couriers").onValue,
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.hasData) {
          List<Courier> couriers = [];

          if (snapshot.data.snapshot.value != null) {
            snapshot.data.snapshot.value.forEach((key, value) {
              var courier = Courier.fromJson(key, value);
              couriers.add(courier);
            });
          }
          if (couriers.length > 0) {
            return buildListView(couriers);
          } else {
            return Center(
              child: Text(
                AppLocalizations.of(context)
                    .translate("courierOperationsError"),
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

  buildListView(List<Courier> couriers) {
    return ListView.builder(
      itemCount: couriers.length,
      itemBuilder: (context, index) {
        var courier = couriers[index];
        return GestureDetector(
          onTap: () {
            buildOptionMenu(couriers[index]);
          },
          child: Card(
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    tileColor: Colors.grey[200],
                    leading: Icon(
                      Icons.motorcycle,
                      color: Constants.redAppColor,
                      size: 30,
                    ),
                    title: Text(
                      courier.courierName + (" ") + courier.courierLastName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(courier.courierUsername),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  buildOptionMenu(Courier courier) {
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
                      db.deleteCourier(courier);
                      Navigator.pop(context);
                    },
                    label: Text(
                      AppLocalizations.of(context)
                          .translate("courierOperationsDelete"),
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.end,
                    ),
                    height: MediaQuery.of(context).size.height * 0.1,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.update),
                    onPressed: () {
                      print(courier.courierId);
                      courierName.text = courier.courierName;
                      courierLastName.text = courier.courierLastName;
                      courierUsername.text = courier.courierUsername;
                      courierPassword.text = courier.courierPassword;
                      buildUpdateDialog(courier);
                    },
                    label: Text(
                      AppLocalizations.of(context)
                          .translate("courierOperationsUpdate"),
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

  buildUpdateDialog(Courier courier) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text(AppLocalizations.of(context)
              .translate("courierOperationsAlertDialogTitle")),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MTextField(
                    label: AppLocalizations.of(context)
                        .translate("courierOperationsAlertDialogHint1"),
                    controller: courierName),
                MTextField(
                    label: AppLocalizations.of(context)
                        .translate("courierOperationsAlertDialogHint2"),
                    controller: courierLastName),
                MTextField(
                    label: AppLocalizations.of(context)
                        .translate("courierOperationsAlertDialogHint3"),
                    controller: courierUsername),
                MTextField(
                    label: AppLocalizations.of(context)
                        .translate("courierOperationsAlertDialogHint4"),
                    controller: courierPassword,
                    obscureText: true),
                Text(AppLocalizations.of(context)
                    .translate("courierOperationsAlertDialogWarn")),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 10),
              child: TextButton(
                  onPressed: () {
                    print(courier.courierId);
                    db
                        .updateCourier(Courier.withId(
                            courier.courierId,
                            courierName.text,
                            courierLastName.text,
                            courierUsername.text,
                            courierPassword.text))
                        .then((value) => {
                              courierName.clear(),
                              courierLastName.clear(),
                              courierUsername.clear(),
                              courierPassword.clear(),
                              Navigator.pop(context),
                              Navigator.pop(context),
                            });
                  },
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("courierOperationsUpdate"),
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ));
  }

  @override
  void dispose() {
    courierName.dispose();
    courierLastName.dispose();
    courierUsername.dispose();
    courierPassword.dispose();
    super.dispose();
  }
}
