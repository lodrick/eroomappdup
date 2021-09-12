import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintTxt;
  final String labelTxt;
  final Icon icon;
  final String initialValue;
  final TextEditingController controller;

  CustomTextField({
    this.hintTxt,
    this.labelTxt,
    this.icon,
    this.initialValue,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: TextFormField(
          autocorrect: true,
          enableInteractiveSelection: true,
          initialValue: initialValue,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(0.0),
              child: icon,
            ),
            filled: false,
            hintStyle: new TextStyle(color: Colors.grey[800]),
            hintText: hintTxt,
            labelText: labelTxt + '*',
            border: InputBorder.none,
          ),
          style: TextStyle(
            fontSize: 16.0,
          ),
          controller: controller,
        ),
      ),
    );
  }
}
