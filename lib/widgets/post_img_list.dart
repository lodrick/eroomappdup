import 'package:flutter/material.dart';

class PostImgList extends StatefulWidget {
  @override
  _PostImgListState createState() => _PostImgListState();
}

class _PostImgListState extends State<PostImgList> {
  int _selectedIndex = 0;
  final List<String> _imgUrl = ['assets/img/login.png'];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      color: Colors.blueGrey,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imgUrl.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 20.0,
              ),
              child: Text(
                _imgUrl[index],
                style: TextStyle(
                  color:
                      index == _selectedIndex ? Colors.white : Colors.white54,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
