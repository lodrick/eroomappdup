import 'package:eRoomApp/stores/login_store.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/loader_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class CustomDialogBox extends StatelessWidget {
  final String title, descriptions, text;
  final String imgUrl;

  const CustomDialogBox({
    Key key,
    this.title,
    this.descriptions,
    this.text,
    this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: loginStore.isLoginLoading,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ConstantVal.padding),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: contentBox(context, loginStore),
            ),
          ),
        );
      },
    );
  }

  contentBox(context, loginStore) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: ConstantVal.padding,
              top: ConstantVal.avatarRadius + ConstantVal.padding,
              right: ConstantVal.padding,
              bottom: ConstantVal.padding),
          margin: EdgeInsets.only(top: ConstantVal.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(ConstantVal.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, 5.0),
                    blurRadius: 6.0)
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                descriptions,
                style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel'.toUpperCase(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    FlatButton(
                      onPressed: () {
                        loginStore.signOut(context);
                      },
                      child: Text(
                        'Yes'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 18, color: MyColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: ConstantVal.padding,
          right: ConstantVal.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 50,
            child: CircleAvatar(
              backgroundColor: MyColors.primaryColor,
              radius: 50.0,
              backgroundImage: NetworkImage(
                imgUrl ??
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/President_Barack_Obama.jpg/480px-President_Barack_Obama.jpg',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ConstantVal {
  ConstantVal._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
