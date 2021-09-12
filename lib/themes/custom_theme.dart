import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: MyColors.primaryColor,
      scaffoldBackgroundColor: Colors.white,
      textTheme: ThemeData.light().textTheme,
      primarySwatch: Colors.amber,
      accentColor: Colors.amber,
    );
  }
}
