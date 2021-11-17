import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';

class DialogAdReview extends StatelessWidget {
  final String title;
  final String descrition;
  final String buttonText;
  final String imageUrl;

  DialogAdReview({
    this.title,
    this.descrition,
    this.buttonText,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor.withAlpha(3).withOpacity(.2),
      body: Container(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: dialogContent(context),
        ),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 100.0,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          margin: EdgeInsets.only(top: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(17.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 16.0),
              Text(descrition, style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(width: 8.0),
                    // ignore: deprecated_member_use
                    FlatButton(
                      color: MyColors.primaryColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'OK'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 0.0,
          left: 16.0,
          right: 16.0,
          child: CircleAvatar(
            backgroundColor: MyColors.primaryColor,
            radius: 50.0,
            backgroundImage: NetworkImage(
              imageUrl != null ? imageUrl : '',
            ),
          ),
        ),
      ],
    );
  }
}
