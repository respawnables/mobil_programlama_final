import 'dart:async';

import 'package:beklegeliyy/AppLocalizations.dart';
import 'package:beklegeliyy/Constants.dart';
import 'package:beklegeliyy/models/Order.dart';
import 'package:beklegeliyy/widgets/MAppBar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrack extends StatefulWidget {
  final Order order;

  OrderTrack(this.order);

  @override
  _OrderTrackState createState() => _OrderTrackState();
}

class _OrderTrackState extends State<OrderTrack> {
  double latitude = 0.0;
  double longitude = 0.0;

  List<double> data = [];
  List<Marker> markers = <Marker>[];

  Completer<GoogleMapController> mapController = Completer();

  Future<void> getMyLocation() async {
    var location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitude = location.latitude;
      longitude = location.longitude;
    });

    GoogleMapController controller = await mapController.future;
    var myLocation =
        CameraPosition(target: LatLng(latitude, longitude), zoom: 9);
    controller.animateCamera(CameraUpdate.newCameraPosition(myLocation));
  }

  addMarker() {
    var orderMarker = Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: MarkerId('orderMarker'),
      position: LatLng(data[0], data[1]),
    );

    var myMarker = Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId('myMarker'),
        position: LatLng(latitude, longitude));
    markers.add(orderMarker);
    markers.add(myMarker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: buildFAB(),
        appBar: MAppBar(
            title: AppLocalizations.of(context)
                .translate("orderDeliveryPageTitle")),
        body: Container(
          height: MediaQuery.of(context).size.height / 2,
          child: StreamBuilder(
            stream: FirebaseDatabase.instance
                .reference()
                .child("orders")
                .child(widget.order.orderId)
                .child("adress")
                .onValue,
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.snapshot.value != null) {
                  snapshot.data.snapshot.value.forEach((key, value) {
                    data.add(value);
                  });
                  addMarker();
                  return buildMap();
                } else {
                  return Center(
                    child: Text(
                      "Henüz Hiç Ürün Yok !",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }

  Widget buildMap() {
    return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(latitude, longitude), zoom: 9),
        markers: Set<Marker>.of(markers),
        onMapCreated: (GoogleMapController controller) {
          mapController.complete(controller);
        });
  }

  buildFAB() {
    return FloatingActionButton(
      backgroundColor: Constants.redAppColor,
      onPressed: () {
        getMyLocation();
      },
      child: Icon(
        Icons.location_on,
        color: Colors.white,
      ),
    );
  }
}
