import 'package:eRoomApp/shared/sharedPreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:eRoomApp/stores/login_store.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/loader_hud.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: loginStore.isLoginLoading,
            child: Scaffold(
              backgroundColor: Colors.white,
              key: loginStore.loginScaffoldKey,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                        height: 240,
                                        constraints: const BoxConstraints(
                                          maxWidth: 500,
                                        ),
                                        margin: const EdgeInsets.only(
                                          top: 100,
                                        ),
                                        decoration: const BoxDecoration(
                                          //color: Color(0xFFE1E0F5),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxHeight: 340,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 5.0),
                                        child: Image.asset(
                                            'assets/img/eroom_logo.jpeg'),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  'eRoomApp',
                                  style: TextStyle(
                                    color: MyColors.primaryColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 500,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: 'We will send you an ',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'One Time Password ',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'on this mobile number',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              Container(
                                height: 40,
                                constraints: const BoxConstraints(
                                  maxWidth: 500,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: CupertinoTextField(
                                  enableInteractiveSelection: true,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                  controller: phoneController,
                                  clearButtonMode:
                                      OverlayVisibilityMode.editing,
                                  keyboardType: TextInputType.phone,
                                  maxLines: 1,
                                  placeholder: '076...',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                constraints: const BoxConstraints(
                                  maxWidth: 500,
                                ),
                                child: RaisedButton(
                                  onPressed: () {
                                    if (phoneController.text.isNotEmpty) {
                                      if (phoneController.text
                                          .startsWith('+27')) {
                                        phoneNumber =
                                            phoneController.text.toString();
                                      } else if (phoneController.text
                                          .startsWith('0')) {
                                        phoneNumber = phoneController.text
                                            .replaceFirst('0', '+27');
                                        print(phoneNumber);
                                      } else {
                                        loginStore.loginScaffoldKey.currentState
                                            .showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor:
                                                Colors.black.withOpacity(0.8),
                                            content: Text(
                                              'Please enter a correct phone number formart',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      loginStore.getCodeWithPhoneNumber(
                                          context, phoneNumber);
                                      SharedPrefs.saveContactNumber(
                                          phoneNumber);
                                    } else {
                                      loginStore.loginScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.8),
                                        content: Text(
                                          'Please enter a phone number',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                          ),
                                        ),
                                      ));
                                    }
                                  },
                                  color: MyColors.primaryColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Next',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            color: MyColors.primaryColorLight,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
