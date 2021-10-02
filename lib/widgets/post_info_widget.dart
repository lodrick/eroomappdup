import 'package:eRoomApp/api/firebase_api.dart';
import 'package:eRoomApp/app_launcher_utils.dart';
import 'package:eRoomApp/shared/sharedPreferences.dart';
import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';

class PostInfo extends StatefulWidget {
  final String idAd;
  final String title;
  final String description;
  final String province;
  final String city;
  final String suburb;
  final String status;
  final String price;
  final String userId;
  final String updatedAt;
  final List<String> imageUrls;

  PostInfo({
    @required this.idAd,
    @required this.title,
    @required this.description,
    @required this.province,
    @required this.city,
    @required this.suburb,
    @required this.price,
    @required this.status,
    @required this.userId,
    @required this.updatedAt,
    @required this.imageUrls,
  });

  @override
  _PostInfoState createState() => _PostInfoState();
}

class _PostInfoState extends State<PostInfo> {
  String authToken;
  String currentUserId;
  List<String> imageUrls;
  /*final List<String> images = [
    'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
    'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
    'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
    'https://images.unsplash.com/photo-1586902279476-3244d8d18285?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
    'https://images.unsplash.com/photo-1586943101559-4cdcf86a6f87?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1556&q=80',
    'https://images.unsplash.com/photo-1586951144438-26d4e072b891?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
    'https://images.unsplash.com/photo-1586953983027-d7508a64f4bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  ];*/

  void authForToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      authToken = preferences.getString('auth_token');
    });
  }

  void currentUser() async {
    SharedPrefs.getContactNumber().then((currentUserPhone) {
      FirebaseApi.retriveUser(currentUserPhone).then((currentUser) {
        setState(() {
          currentUserId = currentUser.idUser;
        });
      });
    });
  }

  void addPostFramecallback() {
    imageUrls = List<String>();
    if (widget.imageUrls.isNotEmpty && widget.imageUrls.length > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.imageUrls.isNotEmpty) {
          widget.imageUrls.forEach((imageUrl) {
            precacheImage(NetworkImage(imageUrl), context);
          });
        }
      });
    }
  }

  @override
  void initState() {
    currentUser();

    addPostFramecallback();
    super.initState();
  }

  @override
  void dispose() {
    imageUrls.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.primaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white70),
          centerTitle: false,
          title: Text(
            'Post Info',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 15.0),
              child: GestureDetector(
                onTap: share,
                child: Icon(Icons.share, size: 22.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {
                  /*BusinessApi.createFavouriteAdvert(
                      widget.userId, widget.idAd, widget.authToken);
                  print('Like');*/
                },
                child: Icon(Icons.thumb_up, size: 22.0),
              ),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            return Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                              child: Container(
                                child: CarouselSlider.builder(
                                  itemCount: widget.imageUrls.length,
                                  options: CarouselOptions(
                                      autoPlay: false,
                                      aspectRatio: 2.1,
                                      enlargeCenterPage: true),
                                  itemBuilder: (context, index, realIdx) {
                                    return Container(
                                      child: Center(
                                        child: Image.network(
                                          widget.imageUrls[index],
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            new SingleChildScrollView(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 32.0,
                                          bottom: 20.0,
                                          right: 32.0,
                                          top: 18.0),
                                      child: titleSection(
                                        title: widget.title ?? '',
                                        description: widget.description ?? '',
                                        updatedAt: widget.updatedAt ?? '',
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 32.0, bottom: 20.0),
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              buildText(
                                                  text: 'Province:',
                                                  color: Colors.grey.shade900,
                                                  fontWeight: FontWeight.bold),
                                              buildText(
                                                  text: 'City:',
                                                  color: Colors.grey.shade900,
                                                  fontWeight: FontWeight.bold),
                                              buildText(
                                                  text: 'Suburb:',
                                                  color: Colors.grey.shade900,
                                                  fontWeight: FontWeight.bold),
                                              buildText(
                                                  text: 'Price:',
                                                  color: Colors.grey.shade900,
                                                  fontWeight: FontWeight.bold),
                                              buildText(
                                                  text: 'Status:',
                                                  color: Colors.grey.shade900,
                                                  fontWeight: FontWeight.bold),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 40.0,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              buildText(
                                                  text: widget.province ?? '',
                                                  color: Colors.grey[700]),
                                              buildText(
                                                  text: widget.city ?? '',
                                                  color: Colors.grey[700]),
                                              buildText(
                                                  text: widget.suburb ?? '',
                                                  color: Colors.grey[700]),
                                              buildText(
                                                  text:
                                                      'R ' + widget.price ?? '',
                                                  color: Colors.grey[700]),
                                              buildText(
                                                  text: widget.status ?? '',
                                                  color: Colors.grey[700]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 35.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        _buildButtonColumn(
                                          MyColors.primaryColor,
                                          IconButton(
                                            icon: const Icon(
                                              Icons.chat,
                                              color: MyColors.primaryColor,
                                            ),
                                            tooltip:
                                                'Click here to chat about the post.',
                                            onPressed: () {
                                              // Token token;
                                              // BusinessApi.getUser(
                                              //   userId: widget.userId,
                                              //   authTohen: 'widget.authToken',
                                              // ).then((results) {
                                              setState(
                                                () {
                                                  FirebaseApi.retriveUser(
                                                          'widget.contactNumber')
                                                      .then(
                                                    (result) {
                                                      print('result.idUser: ' +
                                                          result.idUser);
                                                      if (currentUserId ==
                                                          result.idUser) {
                                                        print(currentUserId +
                                                            ' Is eqaul ' +
                                                            result.idUser);
                                                        final snackBar =
                                                            SnackBar(
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors.black38
                                                                  .withOpacity(
                                                                      0.8),
                                                          content: Text(
                                                            'You own this post you can not chat with yourself.',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                0.7,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                        Scaffold.of(context)
                                                            .showSnackBar(
                                                          snackBar,
                                                        );
                                                      } else {
                                                        // Navigator.push(
                                                        //   context,
                                                        //   MaterialPageRoute(
                                                        //     builder:
                                                        //         (context) =>
                                                        //             ChatPage(
                                                        //       currentIdUser:
                                                        //           currentUserId,
                                                        //       user: result,
                                                        //       contactNumber: widget
                                                        //           .contactNumber,
                                                        //     ),
                                                        //   ),
                                                        // );
                                                      }
                                                    },
                                                  );
                                                },
                                              );
                                              // }).catchError((e) {
                                              //   print('BusinessApi.getUser: ' +
                                              //       e.toString());
                                              // });
                                            },
                                          ),
                                          'eRoom Chat',
                                        ),
                                        _buildButtonColumn(
                                          MyColors.primaryColor,
                                          IconButton(
                                            icon: Icon(
                                              Icons.call,
                                              color: MyColors.primaryColor,
                                            ),
                                            onPressed: () =>
                                                AppLauncherUtils.openPhoneCall(
                                              phoneNumber: '+27680308734',
                                            ),
                                          ),
                                          'Call Us',
                                        ),
                                        _buildButtonColumn(
                                          MyColors.primaryColor,
                                          IconButton(
                                            icon: Icon(
                                              Icons.sms,
                                              color: MyColors.primaryColor,
                                            ),
                                            onPressed: () =>
                                                AppLauncherUtils.openSMS(
                                              phoneNumber: '+27680308734',
                                            ),
                                          ),
                                          'SMS',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildText({String text, Color color, FontWeight fontWeight}) =>
      Container(
        padding: EdgeInsets.only(top: 5.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: 14.0,
            color: color,
          ),
          softWrap: true,
        ),
      );

  Widget titleSection({String title, String description, String updatedAt}) =>
      Container(
        padding: const EdgeInsets.only(bottom: 3.5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade800, width: 2.0),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      title ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      softWrap: true,
                    ),
                  ),
                  Text(
                    description ?? '',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.access_time_sharp,
              color: Colors.red[500],
            ),
            Text(updatedAt),
          ],
        ),
      );

  static Column _buildButtonColumn(
      Color color, IconButton iconButton, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconButton,
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> share() async {
    String text = 'https://medium.com/@suryadevsingh24032000';
    String subject = 'follow me';
    final RenderBox box = context.findRenderObject();
    Share.share(text,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
