import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String imageUri;

  const ProfileHeaderWidget({
    @required this.name,
    @required this.imageUri,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        padding: EdgeInsets.all(16).copyWith(left: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: Colors.white),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(imageUri),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.more_vert, size: 25, color: Colors.white),
              ],
            )
          ],
        ),
      );

  Widget buildIcon(IconData icon) => Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white54,
        ),
        child: Icon(
          icon,
          size: 25,
          color: Colors.white,
        ),
      );
}
