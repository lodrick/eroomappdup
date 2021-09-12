import 'dart:ui';
import 'package:eRoomApp/constants.dart';
import 'package:eRoomApp/pages_chat/all_users_page.dart';
import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';
import 'package:eRoomApp/models/user_model.dart';
import 'package:eRoomApp/api/firebase_api.dart';
import 'package:eRoomApp/widgets_chat/chat_body_wiget.dart';
import 'package:eRoomApp/widgets_chat/chat_header_widget.dart';

class ChatsPage extends StatefulWidget {
  final String contactNumber;
  final String currentIdUser;
  ChatsPage({
    @required this.contactNumber,
    @required this.currentIdUser,
    Key key,
  }) : super(key: key);
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: MyColors.primaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white70),
          backgroundColor: MyColors.primaryColor,
          elevation: 0.0,
          title: Text(
            'Chats',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice,
                      style: TextStyle(
                        color: MyColors.primaryColor,
                      ),
                    ),
                  );
                }).toList();
              },
              elevation: 0.0,
            ),
          ],
        ),
        body: SafeArea(
          child: StreamBuilder<List<User>>(
            stream: FirebaseApi.getUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return buildText(
                        'Something Went Wrong Try later, ' + snapshot.error);
                  } else {
                    final users = snapshot.data;

                    if (users.isEmpty) {
                      return buildText('No Users Found.');
                    } else {
                      return Column(
                        children: [
                          ChatHeaderWidget(
                            users: users,
                            contactNumber: widget.contactNumber,
                            currentIdUser: widget.currentIdUser,
                          ),
                          ChatBodyWidget(
                            users: users,
                            contactNumber: widget.contactNumber,
                            currentIdUser: widget.currentIdUser,
                          ),
                        ],
                      );
                    }
                  }
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllUsersChat(
                  contactNumber: widget.contactNumber,
                  currentIdUser: widget.currentIdUser,
                ),
              ),
            );
          },
          child: Icon(
            Icons.chat,
            color: Colors.white,
          ),
          backgroundColor: MyColors.primaryColor,
        ),
        primary: true,
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      );

  void choiceAction(String choice) {
    if (choice == Constants.PROFILE) {
      print('Profile');
    } else if (choice == Constants.SIGNOUT) {
      print('Sign Out');
    }
  }
}
