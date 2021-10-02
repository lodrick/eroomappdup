import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/pages/post_ad_edit.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/dialog_box_stats.dart';
import 'package:flutter/material.dart';

class Favourites extends StatefulWidget {
  final String idUser;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNumber;

  Favourites({
    @required this.idUser,
    @required this.firstName,
    @required this.lastName,
    @required this.contactNumber,
    @required this.email,
    Key key,
  }) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    bool _status = false;
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white70),
        title: Text(
          'Favourite Post',
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.white70,
          ),
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, top: 8.0),
          child: StreamBuilder<List<Advert>>(
            stream: FireBusinessApi.getFavouriteAdvert(widget.idUser, true),
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
                    if (adverts.isEmpty) {
                      return buildText('No Adverts Found');
                    } else {
                      return ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        child: ListView.builder(
                          itemCount: adverts.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Advert advert = adverts[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PostAdEdit(
                                    //authToken: widget.authToken,
                                    advert: advert,
                                    contactNumber: widget.contactNumber,
                                    email: widget.email,
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    idUser: widget.idUser,
                                  ),
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, bottom: 5.0, right: 20.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFEFEE),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 35.0,
                                          backgroundImage: NetworkImage(
                                            'https://images.unsplash.com/photo-1492106087820-71f1a00d2b11?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              advert.title,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5.0),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              child: Text(
                                                advert.decription,
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        String statusDescription = 'pending';
                                        if (advert.status == 'approved')
                                          _status = true;

                                        showDialog(
                                          context: context,
                                          builder: (context) => DialogAdReview(
                                            title: statusDescription,
                                            descrition:
                                                'You are doing a great job please keep it up you are the best',
                                          ),
                                        );
                                      },
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            _status
                                                ? Column(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.check,
                                                        color: MyColors
                                                            .primaryColor,
                                                        size: 45.0,
                                                      ),
                                                      Text(
                                                        'Approved',
                                                        style: TextStyle(
                                                          color: MyColors
                                                              .primaryColor,
                                                          fontSize: 13.5,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons
                                                            .hourglass_top_rounded,
                                                        color:
                                                            Colors.yellow[500],
                                                        size: 45.0,
                                                      ),
                                                      Text(
                                                        'Pending',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 13.5,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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
}
