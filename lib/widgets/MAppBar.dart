import 'package:beklegeliyy/Constants.dart';
import 'package:flutter/material.dart';

class MAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  MAppBar({@required this.title});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(double.infinity, 56),
      child: AppBar(
        backgroundColor: Constants.redAppColor,
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 56);
}
