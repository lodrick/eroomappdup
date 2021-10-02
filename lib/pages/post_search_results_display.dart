import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';

class PostSearchResultsDisplay extends StatelessWidget {
  final double minPrice;
  final double maxPrice;
  final String suburb;
  final String city;

  PostSearchResultsDisplay({
    @required this.minPrice,
    @required this.maxPrice,
    @required this.suburb,
    @required this.city,
    Key key,
  }) : super(key: key);

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
                    child: StreamBuilder<List<Advert>>(
                      stream: FireBusinessApi.getSearchResultAdvert(
                          minPrice, maxPrice, suburb, city),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return buildText(
                                  'Something Went Wrong Try again later, ' +
                                      snapshot.error.toString());
                            } else {
                              var adverts = snapshot.data;

                              if (adverts == null || adverts.isEmpty) {
                                return buildText('No Advert Found');
                              } else {
                                return PostCardWidget(
                                  adverts: adverts,
                                );
                              }
                            }
                        }
                      },
                    ),
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
