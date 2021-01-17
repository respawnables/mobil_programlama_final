import 'package:flutter/material.dart';

import '../Constants.dart';

class MTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  MTextField(
      {@required this.label,
      @required this.controller,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Constants.redAppColor,
              )),
          labelText: label,
        ),
      ),
    );
  }
}
