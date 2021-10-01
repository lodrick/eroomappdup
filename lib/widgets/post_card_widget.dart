import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eRoomApp/api/firebase_api.dart';
import 'package:eRoomApp/models/advert.dart';

import 'package:eRoomApp/models/post_like.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/post_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCardWidget extends StatefulWidget {
  final List<Advert> adverts;
  final String contactNumber;

  const PostCardWidget(
      {@required this.adverts, @required this.contactNumber, Key key})
      : super(key: key);

  @override
  _PostCardWidgetState createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  List<String> _imageUrls;
  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: buildAdverts(),
    );
  }

  Widget buildAdverts() => ListView.builder(
        physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
        reverse: false,
        itemCount: widget.adverts.length,
        itemBuilder: (context, index) {
          Advert advert = widget.adverts[index];
          List<String> photos = List<String>();
          //DateTime updatedAt = DateTime.parse(advert.updatedAt);
          //DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(
          //   advert.updatedAt); //from firebase
          /*var value = FirebaseFirestore.instance
              .collection('adverts')
              .doc(advert.id)
              .get()
              .then((result) {
            return result.data()['photosUrl'].forEach((f) {
              return photos.add(f['photoUrl']);
            });
          });*/

          String updatedAt = DateFormat('dd-MM-yyy')
              .format(DateTime.parse(advert.updatedAt.toDate().toString()));
          bool isAdvertLiked = false;
          _imageUrls = new List<String>();

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostInfo(
                    idAd: advert.id,
                    title: advert.title,
                    description: advert.decription,
                    province: advert.province,
                    city: advert.city,
                    suburb: advert.suburb,
                    price: advert.price.toString(),
                    status: advert.status,
                    userId: advert.userId,
                    updatedAt: updatedAt,
                    imageUrls: _imageUrls,
                  ),
                ),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 2.2,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: <Widget>[
                    FutureBuilder<dynamic>(
                      future: FirebaseFirestore.instance
                          .collection('adverts')
                          .doc(advert.id)
                          .get(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                                color: MyColors.primaryColor,
                                child:
                                    Center(child: CircularProgressIndicator()));
                          default:
                            String url = '';
                            if (snapshot.hasError) {
                            } else {
                              //print();
                              snapshot.data['photosUrl'].forEach((f) {
                                //print(f['photoUrl'][0]);
                                url = f['photoUrl'];
                              });
                              print(url);
                            }
                            return Container(
                              alignment: Alignment.center,
                              child: Container(
                                width: 400.0,
                                height: 200.0,
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(url.isEmpty
                                        ? url
                                        : 'https://i.imgur.com/GXoYikT.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                        }
                      },
                    ),
                    /*Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 400.0,
                        height: 200.0,
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          image: DecorationImage(
                              image: NetworkImage(imageUrl.isNotEmpty
                                  ? imageUrl
                                  : 'https://i.imgur.com/GXoYikT.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),*/
                    ListTile(
                      leading: Icon(
                        Icons.house,
                        color: MyColors.primaryColor,
                        size: 30.0,
                      ),
                      title: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          advert.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 19.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      subtitle: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          advert.decription,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 16.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                      child: Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.lock_clock,
                                color: Colors.blueGrey,
                              ),
                              Text(updatedAt)
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: Text(
                              'Available',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.amberAccent,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(
                                  Icons.add_shopping_cart,
                                  color: MyColors.primaryColor,
                                ),
                                Text(
                                  'R ' + advert.price.toString(),
                                  style: TextStyle(
                                    color: MyColors.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 18.0),
                                GestureDetector(
                                  onTap: () {
                                    FirebaseApi.getLikeObj(
                                            adId: advert.id,
                                            currentUserId: advert.userId)
                                        .then((result) {
                                      print("Entered");
                                      print(result.baseId);
                                      PostLike postLike;
                                      if (result != null) {
                                        if (result.like == true) {
                                          postLike = PostLike(
                                              like: false,
                                              adId: advert.id,
                                              currentUserId: advert.userId,
                                              baseId: result.baseId);
                                          isAdvertLiked = false;
                                        } else {
                                          postLike = PostLike(
                                              like: true,
                                              adId: advert.id,
                                              currentUserId: advert.userId,
                                              baseId: result.baseId);
                                          isAdvertLiked = true;
                                        }

                                        FirebaseApi.updatePostLike(postLike);
                                      }
                                    });
                                    /*PostLike postLike = PostLike(
                                        like: true,
                                        adId: advert.id,
                                        currentUserId: advert.userId);
                                    FirebaseApi.updatePostLike(postLike);*/
                                    print('Liked');
                                    print(isAdvertLiked);
                                  },
                                  child: isAdvertLiked == true
                                      ? Icon(
                                          Icons.thumb_up,
                                          color: MyColors.primaryColor,
                                        )
                                      : Icon(
                                          Icons.thumb_up,
                                          color: Colors.blueGrey[400],
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
