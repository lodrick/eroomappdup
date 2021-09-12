import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/post_cards.dart';
import 'package:flutter/material.dart';

class PostSearchResultsDisplay extends StatelessWidget {
  final List adverts;
  final List images;

  PostSearchResultsDisplay({this.adverts, this.images, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.primaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white70),
          centerTitle: false,
          title: Text(
            'Search Results',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    child: adverts != null
                        ? new PostCards(adverts: adverts, images: images)
                        : buildText('No Search Found.'),
                  ),
                ),
              ),
            ),
          ],
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
