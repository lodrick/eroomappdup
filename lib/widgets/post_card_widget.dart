import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/models/advert.dart';

import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/post_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCardWidget extends StatefulWidget {
  final List<Advert> adverts;
  final String contactNumber;

  const PostCardWidget({
    @required this.adverts,
    @required this.contactNumber,
    Key key,
  }) : super(key: key);

  @override
  _PostCardWidgetState createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  List<String> imageUrls;
  bool isLiked = false;
  int _index = 0;
  Map<String, bool> testLike = Map<String, bool>();
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
          imageUrls = new List<String>();
          String _url = '';
          String _updatedAt = DateFormat('dd-MM-yyy')
              .format(DateTime.parse(advert.updatedAt.toDate().toString()));

          if (advert.likes.isNotEmpty) {
            for (int x = 0; x < advert.likes.length; x++) {
              if (advert.likes[x][advert.userId]) {
                print(advert.likes[x][advert.userId]);
                _index = x;
                break;
              }
            }
            print('index: $_index');
          }
          isLiked = advert.likes[_index ?? 1][advert.userId];

          if (advert.photosUrl != null) {
            advert.photosUrl.forEach((e) {
              _url = e['photoUrl'];
            });
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostInfo(
                    isLiked: isLiked,
                    contactNumber: widget.contactNumber,
                    advert: advert,
                  ),
                ),
              );
              //imageUrls = new List<String>();
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 2.2,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: <Widget>[
                    Container(
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
                            image: NetworkImage(_url != null || _url.isNotEmpty
                                ? _url
                                : 'https://i.imgur.com/GXoYikT.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
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
                              Text(_updatedAt)
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
                              overflow: TextOverflow.ellipsis,
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
                                    bool _isLiked = false;
                                    if (advert.likes.isNotEmpty) {
                                      _isLiked =
                                          advert.likes[_index][advert.userId];
                                    }
                                    if (_isLiked) {
                                      FireBusinessApi.updateLikes(
                                        idAd: advert.id,
                                        idUser: advert.userId,
                                        like: false,
                                      );
                                      FireBusinessApi.removeLikes(
                                        idAd: advert.id,
                                        idUser: advert.userId,
                                        like: true,
                                      );

                                      setState(() {
                                        isLiked = false;
                                        if (advert.likes.isNotEmpty) {
                                          advert.likes[_index][advert.userId] =
                                              false;
                                        }
                                      });
                                    } else {
                                      FireBusinessApi.updateLikes(
                                        idAd: advert.id,
                                        idUser: advert.userId,
                                        like: true,
                                      );
                                      FireBusinessApi.removeLikes(
                                        idAd: advert.id,
                                        idUser: advert.userId,
                                        like: false,
                                      );

                                      setState(() {
                                        isLiked = true;
                                        if (advert.likes.isNotEmpty) {
                                          advert.likes[_index][advert.userId] =
                                              true;
                                        }
                                      });
                                    }
                                  },
                                  child: Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isLiked
                                        ? Colors.pink[400]
                                        : Colors.black54,
                                  ),
                                ),
                                Text('1'),
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
