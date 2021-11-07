import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';

class OpagueImage extends StatelessWidget {
  final imageUrl;
  const OpagueImage({Key key, @required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          imageUrl,
          width: double.maxFinite,
          height: double.maxFinite,
        ),
        Container(
          color: MyColors.primaryColor.withOpacity(.85),
        ),
      ],
    );
  }
}
