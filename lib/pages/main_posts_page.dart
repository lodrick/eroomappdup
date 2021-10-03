import 'package:eRoomApp/api/business_api.dart';
import 'package:eRoomApp/api/firebase_api.dart';
import 'package:eRoomApp/constants.dart';
import 'package:eRoomApp/models/user_model.dart';

import 'package:eRoomApp/pages/contact_us.dart';
import 'package:eRoomApp/pages/create_post.dart';
import 'package:eRoomApp/pages/favourites.dart';
import 'package:eRoomApp/pages/inbox.dart';
import 'package:eRoomApp/pages/main_search_post_page.dart';

import 'package:eRoomApp/widgets/dialog_box_exit_app.dart';
import 'package:eRoomApp/widgets/mybutton.dart';
import 'package:eRoomApp/widgets/post_cards.dart';
import 'package:eRoomApp/widgets/posts_list_apartments.dart';
import 'package:flutter/material.dart';
import 'package:eRoomApp/pages/profile_page_user_detail_save.dart';
import 'package:eRoomApp/pages_chat/chats_page.dart';
import 'package:eRoomApp/stores/login_store.dart';
import 'package:provider/provider.dart';
import 'package:eRoomApp/theme.dart';

class MainPostsPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String idUser;
  final String email;
  final String contactNumber;

  const MainPostsPage({
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.idUser,
    @required this.contactNumber,
    Key key,
  }) : super(key: key);
  @override
  _MainPostsPageState createState() => _MainPostsPageState();
}

class _MainPostsPageState extends State<MainPostsPage> {
  String url = BusinessApi.url;
  int _bottomBarIndex = 0;
  var currentImageUrl;
  String contactNumber;
  String currentIdUser;

  void _onItemTap(int index) {
    setState(() {
      _bottomBarIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double menuContainerHeight = mediaQuery.height / 2;

    List<Widget> _widgetOptions = <Widget>[
      PostCards(
        contactNumber: widget.contactNumber,
      ),
      CreatePost(
        firstName: widget.firstName,
        lastName: widget.lastName,
        contactNumber: widget.contactNumber,
        email: widget.email,
        idUser: widget.idUser,
      ),
      MainSearchPostPage(),
    ];

    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        String names = '';
        String email = '';

        return FutureBuilder<User>(
          future: FirebaseApi.retriveUser(
              loginStore.firebaseUser.phoneNumber.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
            } else if (snapshot.hasData) {
              names = snapshot.data.name + ' ' + snapshot.data.surname;
              email = snapshot.data.email;
              currentImageUrl = snapshot.data.imageUrl;

              if ((snapshot.data.name.toString().isNotEmpty) &&
                  (snapshot.data.surname.toString().isNotEmpty) &&
                  (snapshot.data.email.toString().isNotEmpty)) {
                contactNumber = snapshot.data.contactNumber;
                currentIdUser = snapshot.data.idUser;
              }
            }
            return SafeArea(
              child: Scaffold(
                backgroundColor: MyColors.primaryColor,
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.white70),
                  centerTitle: false,
                  title: Text(
                    'eRoom',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  elevation: 0.0,
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainSearchPostPage(
                              //authToken: widget.authToken,
                              ),
                        ),
                      ),
                      child: Icon(Icons.search, size: 25.0),
                    ),
                    PopupMenuButton<String>(
                      onSelected: choiceAction,
                      itemBuilder: (BuildContext context) {
                        return Constants.choices.map(
                          (String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(
                                choice,
                                style: TextStyle(
                                  color: MyColors.primaryColor,
                                ),
                              ),
                            );
                          },
                        ).toList();
                      },
                      elevation: 0.0,
                    ),
                  ],
                ),
                body: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: _widgetOptions.elementAt(_bottomBarIndex),
                  ),
                ),
                drawer: Drawer(
                  child: SingleChildScrollView(
                    physics:
                        BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/img/black-house-01.jpeg',
                                bundle: null,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.black54,
                                      MyColors.primaryColor
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 25.0, bottom: 25.0),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 105.0,
                                          width: 105.0,
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                              Radius.circular(60.0),
                                            ),
                                            image: new DecorationImage(
                                              image: new AssetImage(
                                                  'assets/img/black-house-01.jpeg'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: _navigatorToprofile,
                                            child: CircleAvatar(
                                              radius: 30.0,
                                              backgroundImage: NetworkImage(
                                                  currentImageUrl ??
                                                      'assets/img/black-house-01.jpeg'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          names ?? 'John Doe',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Text(
                                          email ?? 'johndoe@gmail.com',
                                          style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Container(
                                  width: double.infinity,
                                  height: menuContainerHeight * 1.45,
                                  child: Column(
                                    children: <Widget>[
                                      MyButton(
                                        text: 'Profile',
                                        iconData: Icons.person,
                                        textSize: 16.0,
                                        height: (menuContainerHeight) / 8,
                                        widget: ProfilePageUserDetailSave(
                                          imageUrl: currentImageUrl,
                                          currentIdUser: currentIdUser,
                                        ),
                                      ),
                                      MyButton(
                                        text: 'Inbox',
                                        iconData: Icons.mark_email_unread,
                                        textSize: 16.0,
                                        height: (menuContainerHeight) / 8,
                                        widget: Inbox(
                                          idUser: widget.idUser,
                                        ),
                                      ),
                                      MyButton(
                                        text: 'My Post',
                                        iconData: Icons.ad_units,
                                        textSize: 16.0,
                                        height: (menuContainerHeight) / 8,
                                        widget: PostsListApartments(
                                          contactNumber: widget.contactNumber,
                                          email: widget.email,
                                          firstName: widget.firstName,
                                          lastName: widget.lastName,
                                          idUser: widget.idUser,
                                        ),
                                      ),
                                      MyButton(
                                        text: 'eRoom Chats',
                                        iconData: Icons.chat,
                                        textSize: 16.0,
                                        height: (menuContainerHeight) / 8,
                                        widget: ChatsPage(
                                          contactNumber: contactNumber,
                                          currentIdUser: currentIdUser,
                                        ),
                                      ),
                                      MyButton(
                                        text: 'Favourites',
                                        iconData: Icons.favorite,
                                        textSize: 16.0,
                                        height: (menuContainerHeight) / 8,
                                        widget: Favourites(
                                          idUser: widget.idUser,
                                          contactNumber: widget.contactNumber,
                                          email: widget.email,
                                          firstName: widget.firstName,
                                          lastName: widget.lastName,
                                        ),
                                      ),
                                      MyButton(
                                        text: 'Contact Us',
                                        iconData: Icons.contact_phone,
                                        textSize: 16.0,
                                        height: (menuContainerHeight) / 8,
                                        widget: ContactUs(),
                                      ),
                                      Divider(
                                        thickness: 1.0,
                                        color: MyColors.primaryColor,
                                      ),
                                      FlatButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Logout',
                                              style: TextStyle(
                                                color:
                                                    MyColors.primaryColorLight,
                                                fontSize: 16.0,
                                                shadows: [
                                                  Shadow(
                                                      color: Colors.black
                                                          .withOpacity(0.8),
                                                      offset: Offset(8.0, 6.0),
                                                      blurRadius: 15),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.logout,
                                              color: MyColors.primaryColorLight,
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CustomDialogBox(
                                              title: 'Exit App',
                                              descriptions:
                                                  'Are you sure you want to exit the app?',
                                              text: '',
                                              imgUrl: currentImageUrl ??
                                                  'assets/img/black-house-01.jpeg',
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.shifting,
                  selectedItemColor: MyColors.primaryColor,
                  unselectedItemColor: Colors.blueGrey,
                  selectedFontSize: 15.0,
                  unselectedFontSize: 14.0,
                  onTap: _onItemTap,
                  currentIndex: _bottomBarIndex,
                  items: [
                    BottomNavigationBarItem(
                        icon: new Icon(Icons.home), label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.post_add), label: 'Create Post'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search), label: 'Search Post'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _navigatorToprofile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePageUserDetailSave(
          imageUrl: currentImageUrl,
          currentIdUser: currentIdUser,
        ),
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.PROFILE) {
      print('Profile');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePageUserDetailSave(
            imageUrl: currentImageUrl,
            currentIdUser: currentIdUser,
          ),
        ),
      );
    } else if (choice == Constants.SIGNOUT) {
      print('Sign Out');
      showDialog(
        context: context,
        builder: (context) => CustomDialogBox(
          title: 'Exit App',
          descriptions: 'Are you sure you want to exit the app?',
          text: 'bluh bluh',
          imgUrl: currentImageUrl ?? 'assets/img/black-house-01.jpeg',
        ),
      );
    }
  }
}
