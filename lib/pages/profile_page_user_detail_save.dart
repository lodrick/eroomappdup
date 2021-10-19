import 'dart:io';
import 'dart:typed_data';

import 'package:eRoomApp/api/firebase_api.dart';
import 'package:eRoomApp/pages/main_posts_page.dart';
import 'package:eRoomApp/shared/sharedPreferences.dart';
import 'package:eRoomApp/stores/login_store.dart';
import 'package:eRoomApp/widgets/loader_hud.dart';
import 'package:eRoomApp/widgets/popover.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:eRoomApp/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:eRoomApp/models/user_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;

class ProfilePageUserDetailSave extends StatefulWidget {
  final String imageUrl;
  final String currentIdUser;

  ProfilePageUserDetailSave({
    this.imageUrl,
    this.currentIdUser,
    Key key,
  }) : super(key: key);

  @override
  _ProfilePageUserDetailSaveState createState() =>
      _ProfilePageUserDetailSaveState();
}

class _ProfilePageUserDetailSaveState extends State<ProfilePageUserDetailSave> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userShortDescriptionController =
      TextEditingController();
  var imageUrl;

  @override
  void initState() {
    print(widget.currentIdUser);
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.clear();
    lastNameController.clear();
    contactNumberController.clear();
    emailController.clear();
    userShortDescriptionController.clear();
    super.dispose();
  }

  _uploadImageFromCamera() async {
    final _imagePicker = ImagePicker();
    PickedFile image;

    var firebaseUser = await FirebaseAuth.instance.currentUser();
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    //Check Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Select Image
      image = await _imagePicker.getImage(source: ImageSource.camera);
      var file = File(image.path);
      String fileName = image.path.split('/').last;
      print(fileName);
      if (file != null) {
        //Upload to Firebase
        String fileName = Path.basename(file.path);
        Uint8List fileByte = file.readAsBytesSync();

        var snapshot = await FirebaseStorage.instance
            .ref()
            .child('profiles/${widget.currentIdUser}/$fileName')
            .putData(fileByte);

        var downLoadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downLoadUrl;
          FirebaseApi.uploadImageUrl(downLoadUrl, widget.currentIdUser);
          userUpdateInfo.photoUrl = downLoadUrl;
          firebaseUser.updateProfile(userUpdateInfo);
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try again with permission access');
    }
  }

  _uploadImageFromLocal() async {
    final _imagePicker = ImagePicker();
    PickedFile image;

    var firebaseUser = await FirebaseAuth.instance.currentUser();
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    //Check Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Select Image
      image = await _imagePicker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if (file != null) {
        String fileName = Path.basename(file.path);
        Uint8List fileByte = file.readAsBytesSync();

        var snapshot = await FirebaseStorage.instance
            .ref()
            .child('profiles/${widget.currentIdUser}/$fileName')
            .putData(fileByte);

        var downLoadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downLoadUrl;
          FirebaseApi.uploadImageUrl(downLoadUrl, widget.currentIdUser);

          userUpdateInfo.photoUrl = downLoadUrl;
          firebaseUser.updateProfile(userUpdateInfo);
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try again with permission access');
    }
  }

  void _handleFABPressed() {
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Popover(
          child: Padding(
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3.8,
              child: ListView.builder(
                physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                itemCount: 1,
                itemBuilder: (BuildContext context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: Container(
                          child: Column(
                        children: <Widget>[
                          Text(
                            'Profile Picture',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: _uploadImageFromCamera,
                            child: ListTile(
                              leading: Icon(
                                Icons.photo_camera,
                                color: MyColors.primaryColor,
                              ),
                              title: Text(
                                "Take picture",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 1.0,
                          ),
                          GestureDetector(
                            onTap: _uploadImageFromLocal,
                            child: ListTile(
                              leading: Icon(
                                Icons.photo_album,
                                color: MyColors.primaryColor,
                              ),
                              title: Text(
                                "Browse picture",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildText(String text) => Container(
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: Colors.blueGrey[300],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    bool _disableButton = true;
    String userShortDesc = 'User availability status description...';

    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: loginStore.isLoginLoading,
            child: FutureBuilder<User>(
              future: FirebaseApi.retriveUser(
                  loginStore.firebaseUser.phoneNumber.toString()),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                        color: MyColors.primaryColor,
                        child: Center(child: CircularProgressIndicator()));
                  default:
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return buildText(
                          'Something Went Wrong Try again later, ' +
                              snapshot.error.toString());
                    } else {
                      if (snapshot.data != null) {
                        if (snapshot.data.name.isNotEmpty) {
                          firstNameController.text =
                              snapshot.data.name.toString();
                        }

                        if (snapshot.data.surname.isNotEmpty) {
                          lastNameController.text =
                              snapshot.data.surname.toString();
                        }

                        if (snapshot.data.email.isNotEmpty) {
                          emailController.text = snapshot.data.email.toString();
                        }
                      }

                      return Scaffold(
                        backgroundColor: MyColors.primaryColor,
                        extendBodyBehindAppBar: true,
                        appBar: AppBar(
                          iconTheme: IconThemeData(color: Colors.white70),
                          backgroundColor: Colors.transparent,
                          title: Text(
                            'User Details',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                          elevation: 0.00,
                        ),
                        body: SafeArea(
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  children: [
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.25,
                                          padding: const EdgeInsets.only(
                                              left: 17.0, right: 17.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30.0),
                                              topRight: Radius.circular(30.0),
                                            ),
                                            image: new DecorationImage(
                                              image: new AssetImage(
                                                'assets/img/black-house.jpeg',
                                                bundle: null,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          child: GestureDetector(
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  MyColors.primaryColor,
                                              radius: 50.0,
                                              backgroundImage: NetworkImage(
                                                widget.imageUrl ??
                                                    imageUrl ??
                                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/President_Barack_Obama.jpg/480px-President_Barack_Obama.jpg',
                                              ),
                                            ),
                                            //onTap: uploadImage,
                                            onTap: _handleFABPressed,
                                          ),
                                          top: 105.0,
                                          left: 16.0,
                                          right: 16.0,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10.0, 10.0, 10.0, 10.0),
                                            height: 120.0,
                                            width: double.maxFinite,
                                            color: Colors.white,
                                            child: Card(
                                              elevation: 5.0,
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Flexible(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  userShortDescriptionController,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    'Enter your status here',
                                                                labelText:
                                                                    'Enter your status here',
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        vertical:
                                                                            5.0),
                                                                labelStyle: new TextStyle(
                                                                    color: MyColors
                                                                        .primaryColor),
                                                                hintStyle: new TextStyle(
                                                                    color: MyColors
                                                                        .primaryColor),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                              child: Text(
                                                                userShortDesc,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: MyColors
                                                              .primaryColor),
                                                    ),
                                                    child: GestureDetector(
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: MyColors
                                                            .primaryColor,
                                                      ),
                                                      onTap: () {
                                                        print('Status edited');
                                                        SharedPrefs.saveUserSatus(
                                                            userShortDescriptionController
                                                                .text
                                                                .toString());
                                                        SharedPrefs
                                                                .getUserStatus()
                                                            .then((results) {
                                                          setState(() {
                                                            print(results);
                                                            userShortDesc =
                                                                results;
                                                          });
                                                        }).catchError((e) {
                                                          print(e);
                                                        });
                                                        print(userShortDesc);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFF8E1),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: TextFormField(
                                                controller: firstNameController
                                                  ..text,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                  ),
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Icon(
                                                      Icons.person,
                                                      color:
                                                          MyColors.primaryColor,
                                                    ),
                                                  ),
                                                  filled: false,
                                                  hintStyle: new TextStyle(
                                                      color: Colors.grey[800]),
                                                  hintText: 'John',
                                                  labelText: 'Name*',
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFF8E1),
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              child: TextFormField(
                                                controller: lastNameController
                                                  ..text,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                  ),
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Icon(
                                                      Icons.person_add,
                                                      color:
                                                          MyColors.primaryColor,
                                                    ),
                                                  ),
                                                  filled: false,
                                                  hintStyle: new TextStyle(
                                                      color: Colors.grey[800]),
                                                  hintText: 'Doe',
                                                  labelText: 'Surname*',
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFF8E1),
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              child: TextFormField(
                                                controller: emailController
                                                  ..text,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                  ),
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Icon(
                                                      Icons.email,
                                                      color:
                                                          MyColors.primaryColor,
                                                    ),
                                                  ),
                                                  filled: false,
                                                  hintStyle: new TextStyle(
                                                      color: Colors.grey[800]),
                                                  hintText:
                                                      'john.doe@gmail.com',
                                                  labelText: 'Email*',
                                                  border: InputBorder.none,
                                                ),
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
                          ),
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: _disableButton
                              ? () {
                                  //showAlert(context);
                                  if (firstNameController.text.isNotEmpty &&
                                      lastNameController.text.isNotEmpty &&
                                      emailController.text.isNotEmpty) {
                                    if (snapshot.data != null) {
                                      print(imageUrl);

                                      User userDataToUpdate = User(
                                        name: firstNameController.text
                                                .toString()
                                                .trim() ??
                                            snapshot.data.name,
                                        surname: lastNameController.text
                                                .toString()
                                                .trim() ??
                                            snapshot.data.surname,
                                        contactNumber: loginStore
                                                .firebaseUser.phoneNumber
                                                .toString() ??
                                            snapshot.data.contactNumber,
                                        email: emailController.text
                                                .toString()
                                                .trim() ??
                                            snapshot.data.email,
                                        country: 'South Africa',
                                        imageUrl: imageUrl != null
                                            ? imageUrl
                                            : 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pngfind.com%2Fmpng%2FmJbmTb_png-file-svg-add-employee-icon-transparent-png%2F&psig=AOvVaw26wyGBlxMUHpu2LNYOjDJg&ust=1626003509118000&source=images&cd=vfe&ved=0CAoQjRxqFwoTCJDWw6O12PECFQAAAAAdAAAAABAD',
                                        lastMessageTime: DateTime.now(),
                                        password: 'password',
                                        userType: 'client',
                                      );
                                      print(snapshot.data.idUser);

                                      FirebaseApi.updateUser(userDataToUpdate,
                                              snapshot.data.idUser)
                                          .then((result) {
                                        MaterialPageRoute(
                                          builder: (context) => MainPostsPage(
                                            firstName: result.name,
                                            lastName: result.surname,
                                            email: result.email,
                                            contactNumber: result.contactNumber,
                                            idUser: result.idUser,
                                          ),
                                        );
                                      });
                                      print('Hey this user exits');

                                      FutureBuilder(
                                        future: FirebaseApi.updateUser(
                                            userDataToUpdate,
                                            snapshot.data.idUser),
                                        builder: (context, snapUser) {
                                          if (snapUser.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container(
                                              color: Colors.transparent,
                                              child: showAlert(context),
                                            );
                                          } else if (snapUser.connectionState ==
                                              ConnectionState.done) {
                                            if (snapUser.hasError) {
                                            } else if (snapUser.hasData) {
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MainPostsPage(
                                                  firstName: snapUser.data.name,
                                                  lastName:
                                                      snapUser.data.surname,
                                                  email: snapUser.data.email,
                                                  contactNumber: snapUser
                                                      .data.contactNumber,
                                                  idUser: snapUser.data.idUser,
                                                ),
                                              );
                                            }
                                          }
                                          return Container(
                                            color: Colors.transparent,
                                            child: showAlert(context),
                                          );
                                        },
                                      );
                                    } else {
                                      print('This user does not exit.');
                                      User user = User(
                                        name: firstNameController.text
                                                .toString()
                                                .trim() ??
                                            '',
                                        surname: lastNameController.text
                                                .toString()
                                                .trim() ??
                                            '',
                                        contactNumber: loginStore
                                                .firebaseUser.phoneNumber
                                                .toString() ??
                                            '',
                                        email: emailController.text
                                                .toString()
                                                .trim() ??
                                            '',
                                        country: 'South Africa',
                                        imageUrl: imageUrl != null
                                            ? imageUrl
                                            //: 'https://thumbs.dreamstime.com/z/default-avatar-profile-image-vector-social-media-user-icon-potrait-182347582.jpg',
                                            : 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pngfind.com%2Fmpng%2FmJbmTb_png-file-svg-add-employee-icon-transparent-png%2F&psig=AOvVaw26wyGBlxMUHpu2LNYOjDJg&ust=1626003509118000&source=images&cd=vfe&ved=0CAoQjRxqFwoTCJDWw6O12PECFQAAAAAdAAAAABAD',
                                        lastMessageTime: DateTime.now(),
                                        password: 'password',
                                        userType: 'client',
                                      );

                                      FirebaseApi.addUser(user).then((result) {
                                        print('Res for firestore data');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MainPostsPage(
                                              firstName: result.name,
                                              lastName: result.surname,
                                              email: result.email,
                                              contactNumber:
                                                  result.contactNumber,
                                              idUser: result.idUser,
                                            ),
                                          ),
                                        );
                                      }).catchError((e) => print(
                                          'Error adding a user from firestore: ' +
                                              e.toString()));

                                      FutureBuilder(
                                        future: FirebaseApi.addUser(user),
                                        builder: (context, snapUser) {
                                          if (snapUser.connectionState ==
                                              ConnectionState.waiting) {
                                            return showAlert(context);
                                          } else if (snapUser.connectionState ==
                                              ConnectionState.done) {
                                            if (snapUser.hasError) {
                                            } else if (snapUser.hasData) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainPostsPage(
                                                    firstName:
                                                        snapUser.data.name,
                                                    lastName:
                                                        snapUser.data.surname,
                                                    email: snapUser.data.email,
                                                    contactNumber: snapUser
                                                        .data.contactNumber,
                                                    idUser:
                                                        snapUser.data.idUser,
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                          return Container(
                                            color: Colors.transparent,
                                            child: showAlert(context),
                                          );
                                        },
                                      );
                                    }
                                  }
                                  clear();
                                }
                              : null,
                          child: Icon(
                            Icons.check,
                            color: Colors.white70,
                          ),
                          backgroundColor: MyColors.primaryColor,
                        ),
                      );
                    }
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          backgroundColor: MyColors.primaryColor,
        ),
      ),
    );
  }

  void clear() {
    firstNameController.clear();
    lastNameController.clear();
    contactNumberController.clear();
    emailController.clear();
    userShortDescriptionController.clear();
  }
}
