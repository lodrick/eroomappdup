import 'package:eRoomApp/api/business_api.dart';
import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';

class PostCards extends StatefulWidget {
  final List adverts;
  final List images;
  final String authToken;
  final String contactNumber;
  final String currentIdUser;

  PostCards({
    this.adverts,
    this.images,
    this.authToken,
    this.contactNumber,
    this.currentIdUser,
    Key key,
  }) : super(key: key);

  @override
  _PostCardsState createState() => _PostCardsState();
}

class _PostCardsState extends State<PostCards> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          /*child: StreamBuilder<List<Advert>>(
            stream: BusinessApi.requestAdverts(widget.authToken)
                .asBroadcastStream(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child:
                          buildText('Something Went Wrong Try again later, '),
                    );
                  } else {
                    if (snapshot.data.isNotEmpty) {
                      for (int index = 0;
                          index < snapshot.data.length;
                          index++) {
                        print(snapshot.data[index].status);
                        if (snapshot.data[index].status != 'active') {
                          snapshot.data.removeAt(index);
                        }
                      }
                    }

                    var adverts = snapshot.data.reversed.toList();

                    if (adverts.isEmpty) {
                      return buildText('No Advert Found');
                    } else {
                      return PostCardWidget(
                        adverts: adverts,
                        contactNumber: widget.contactNumber,
                        authToken: widget.authToken,
                      );
                    }
                  }
              }
            },
          ),*/
          child: StreamBuilder<List<Advert>>(
            stream: FireBusinessApi.getAdverts(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return buildText('Something Went Wrong Try again later, ' +
                        snapshot.error.toString());
                  } else {
                    var adverts = snapshot.data;
                    print(adverts.elementAt(0).city);

                    if (adverts == null || adverts.isEmpty) {
                      return buildText('No Advert Found');
                    } else {
                      return PostCardWidget(
                        adverts: adverts,
                        contactNumber: widget.contactNumber,
                        authToken: widget.authToken,
                      );
                    }
                  }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            color: Colors.blueGrey[300],
          ),
        ),
      );
  Widget buildAdverts() => ListView.builder(itemBuilder: null);
}
