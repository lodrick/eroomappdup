import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/dialog_box_stats.dart';
import 'package:flutter/material.dart';

class Inbox extends StatelessWidget {
  final String idUser;
  Inbox({
    @required this.idUser,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String imageUrl = '';
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white70),
        title: Text(
          'Notifications',
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
            stream: FireBusinessApi.getMyAdverts(idUser),
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
                      List<Advert> myAdverts = [];
                      for (var advert in adverts) {
                        if (advert.userId == idUser) {
                          myAdverts.add(advert);
                        }
                      }

                      return ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        child: ListView.builder(
                          //controller: _controller,
                          //physics: _physics,
                          itemCount: myAdverts.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Advert advert = myAdverts[index];
                            Color color = Colors.amberAccent;
                            var statusMessage;
                            String _imageUrl = '';
                            advert.photosUrl.forEach((e) {
                              //_imageUrls.add(e['photoUrl']);
                              _imageUrl = e['photoUrl'];
                            });

                            if (advert.status == 'pending') {
                              statusMessage =
                                  'Your post is under review, you will receive an email when it has been declined or approved';
                              color = Colors.yellow[500];
                            } else if (advert.status == 'approved') {
                              statusMessage =
                                  'Your post has been Accepted and can be viewed online';
                              color = MyColors.primaryColor;
                            } else if (advert.status == 'rejected') {
                              statusMessage =
                                  'Your post has been declined, please check your email why it was declined';
                              color = Colors.redAccent;
                            }

                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => DialogAdReview(
                                    title: advert.status
                                            .substring(0, 1)
                                            .toLowerCase() +
                                        advert.status.substring(1),
                                    descrition: '',
                                    imageUrl: imageUrl,
                                  ),
                                );
                              },
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
                                            _imageUrl.isNotEmpty
                                                ? _imageUrl
                                                : 'https://images.unsplash.com/photo-1492106087820-71f1a00d2b11?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                                          ),
                                          backgroundColor:
                                              MyColors.primaryColor,
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
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => DialogAdReview(
                                            title: advert.status
                                                    .substring(0, 1)
                                                    .toLowerCase() +
                                                advert.status.substring(1),
                                            imageUrl: _imageUrl.isNotEmpty
                                                ? _imageUrl
                                                : '',
                                            descrition: statusMessage,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.email,
                                                  color: color,
                                                  size: 45.0,
                                                ),
                                              ],
                                            )
                                            /*if (advert.status == 'active')
                                              
                                            else if (advert.status == 'pending')
                                              Column(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.email,
                                                    color: Colors.yellow[500],
                                                    size: 45.0,
                                                  ),
                                                ],
                                              )
                                            else if (advert.status ==
                                                'rejected')
                                              Column(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.email,
                                                    color: Colors.redAccent,
                                                    size: 45.0,
                                                  ),
                                                ],
                                              )*/
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
          style: TextStyle(fontSize: 24, color: Colors.blueGrey[300]),
        ),
      );
}
