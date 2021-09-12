import 'package:eRoomApp/api/business_api.dart';
import 'package:eRoomApp/pages/main_posts_page.dart';
import 'package:eRoomApp/shared/sharedPreferences.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eRoomApp/pages/login_page.dart';
import 'package:eRoomApp/stores/login_store.dart';
import 'package:eRoomApp/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<LoginStore>(context, listen: false)
        .isAlreadyAuthenticated()
        .then((result) {
      if (result) {
        currentUser();
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (Route<dynamic> route) => false);
      }
    });
  }

  void currentUser() {
    SharedPrefs.getContactNumber().then((cNumber) {
      if (cNumber.isNotEmpty) {
        BusinessApi.authenticate(cNumber).then((result) {
          setState(() {
            print('result.email ' + result.email);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => MainPostsPage(
                    firstName: result.firstName,
                    lastName: result.lastName,
                    email: result.email,
                    authToken: result.authToken,
                    contactNumber: result.phoneNumber,
                    id: result.id,
                  ),
                ),
                (Route<dynamic> route) => false);
          });
        }).catchError((e) {});
      }
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
    );
  }
}
