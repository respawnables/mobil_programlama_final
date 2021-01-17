import 'package:beklegeliyy/AppLocalizations.dart';
import 'package:beklegeliyy/Constants.dart';
import 'package:beklegeliyy/screens/CartPage.dart';
import 'package:beklegeliyy/screens/ProfilePage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> imgList = [
    "assets/slider/slider1.png",
    "assets/slider/slider2.png",
    "assets/slider/slider3.png",
    "assets/slider/slider4.png",
    "assets/slider/slider5.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Center(
          child: Constants.appBarLogo,
        ),
        backgroundColor: Constants.redAppColor,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                AppLocalizations.of(context).translate('homePageTitle'),
                style: TextStyle(
                    fontFamily: "nunito",
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            buildSlider(),
          ],
        ),
      ),
      floatingActionButton: buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CartPage()));
      },
      child: Icon(
        Icons.shopping_cart,
        color: Constants.redAppColor,
      ),
      backgroundColor: Colors.white,
      elevation: 2.0,
    );
  }

  Widget buildBottomBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.fastfood),
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              onPressed: () {
                Navigator.pushNamed(context, '/productList');
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle_rounded),
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
          ],
        ),
      ),
      color: Constants.redAppColor,
    );
  }

  Widget buildSlider() {
    return CarouselSlider(
      options: CarouselOptions(height: 150.0, autoPlay: true),
      items: imgList.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.asset(i),
            );
          },
        );
      }).toList(),
    );
  }
}
