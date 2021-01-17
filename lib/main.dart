import 'package:beklegeliyy/Constants.dart';
import 'package:beklegeliyy/screens/CartPage.dart';
import 'package:beklegeliyy/screens/Login.dart';
import 'package:beklegeliyy/screens/ProductList.dart';
import 'package:beklegeliyy/screens/Signup.dart';
import 'package:beklegeliyy/screens/admin/AdminHomePage.dart';
import 'package:beklegeliyy/screens/admin/CourierAddPage.dart';
import 'package:beklegeliyy/screens/admin/CourierOperations.dart';
import 'package:beklegeliyy/screens/admin/ProductAddPage.dart';
import 'package:beklegeliyy/screens/admin/ProductOperations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'AppLocalizations.dart';
import 'screens/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "beklegeliyy",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'nunito',
        primaryColor: Constants.redAppColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: userControl(),
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/productList': (context) => ProductList(),
        '/cartPage': (context) => CartPage(),
        '/adminHomePage': (context) => AdminHomePage(),
        '/courierAddPage': (context) => CourierAddPage(),
        '/courierOperations': (context) => CourierOperations(),
        '/productAddPage': (context) => ProductAddPage(),
        '/productOperations': (context) => ProductOperations(),
      },
      supportedLocales: [
        Locale('en', 'US'),
        Locale('tr', 'TR'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }

  String userControl() {
    if (auth.currentUser != null) {
      return '/';
    }
    else {
      return '/login';
    }
  }
}
