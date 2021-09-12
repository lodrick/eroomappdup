import 'package:flutter/material.dart';
import 'package:eRoomApp/models/user_model.dart';
import 'package:eRoomApp/pages_chat/chat_page.dart';

class ChatHeaderWidget extends StatelessWidget {
  final List<User> users;
  final String contactNumber;
  final String currentIdUser;

  const ChatHeaderWidget({
    @required this.users,
    @required this.contactNumber,
    @required this.currentIdUser,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Text(
                'Favourites',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  if (currentIdUser == user.idUser) {
                    return SizedBox.shrink();
                  } else {
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                              user: users[index],
                              contactNumber: contactNumber,
                              currentIdUser: currentIdUser,
                            ),
                          ));
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(user.imageUrl),
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      );
}
