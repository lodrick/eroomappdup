import 'dart:io';

import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/models/static_data.dart';
import 'package:eRoomApp/pages/main_posts_page.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/custom_textfield.dart';
import 'package:eRoomApp/widgets/popover.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePost extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String idUser;
  final String email;
  final String contactNumber;

  CreatePost({
    @required this.firstName,
    @required this.lastName,
    @required this.idUser,
    @required this.email,
    @required this.contactNumber,
    Key key,
  }) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String _province;
  String _roomType;
  String _city;

  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController decriptionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController suburbController = TextEditingController();
  List<Asset> images = <Asset>[];

  String token = '';

  Future<void> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('auth_token');
  }

  @override
  void initState() {
    this.getToken();
    super.initState();
  }

  //Remove this code
  Widget buildMultiChoice(
      List<String> items, String selectedItem, String itemHint) {
    final List<String> options = items.toList();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton(
        dropdownColor: MyColors.primaryColor,
        underline: SizedBox(),
        value: selectedItem,
        hint: Text(
          itemHint,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        isExpanded: true,
        iconSize: 30.0,
        style: TextStyle(
          color: Colors.white,
        ),
        items: options.map(
          (val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(
                val,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        ).toList(),
        onChanged: (val) {
          setState(() {
            selectedItem = val;
            print('Yeah: ' + selectedItem);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    priceController.dispose();
    titleController.dispose();
    decriptionController.dispose();
    cityController.dispose();
    suburbController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: SafeArea(
        //onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 25.0, left: 16.0, right: 16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: DropdownButton(
                      dropdownColor: Colors.white,
                      underline: SizedBox(),
                      value: _roomType,
                      hint: Text(
                        'Select Room/Type',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      items: StaticData.roomTypesCottage.map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          _roomType = val;
                          print('Yeah: ' + _roomType);
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 4.0),
                  CustomTextField(
                    hintTxt: '4800.00',
                    labelTxt: 'Price',
                    icon: Icon(
                      Icons.money,
                      color: MyColors.primaryColor,
                    ),
                    controller: priceController,
                  ),
                  CustomTextField(
                    hintTxt: 'Incredible room a bachelar',
                    labelTxt: 'Title',
                    icon: Icon(
                      Icons.title,
                      color: MyColors.primaryColor,
                    ),
                    controller: titleController,
                  ),
                  CustomTextField(
                    hintTxt: 'A stylish great room suitable for a stylish',
                    labelTxt: 'Description',
                    icon: Icon(
                      Icons.description,
                      color: MyColors.primaryColor,
                    ),
                    controller: decriptionController,
                  ),
                  SizedBox(height: 4.0),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: DropdownButton(
                      dropdownColor: Colors.white,
                      underline: SizedBox(),
                      value: _province,
                      hint: Text(
                        'Select Province',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      items: StaticData.provinces.map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          _province = val;
                          print(_province);
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: DropdownButton(
                      dropdownColor: Colors.white,
                      underline: SizedBox(),
                      value: _city,
                      hint: Text(
                        'Select City',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      items: StaticData.cities.map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          _city = val;
                          print(_city);
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 4.0),
                  CustomTextField(
                    hintTxt: 'Midrand',
                    labelTxt: 'Suburb',
                    icon: Icon(
                      Icons.location_city,
                      color: MyColors.primaryColor,
                    ),
                    controller: suburbController,
                  ),
                  SizedBox(height: 3.0),
                  IconButton(
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: MyColors.primaryColor,
                      size: 40.0,
                    ),
                    tooltip: 'Add Images',
                    onPressed: () {
                      showModalBottomSheet<int>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Popover(
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 3.8,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  itemCount: 1,
                                  itemBuilder: (BuildContext context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin: EdgeInsets.all(5.0),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.0, vertical: 0.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Container(
                                            child: Column(
                                          children: <Widget>[
                                            Text(
                                              'Upload Picture',
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
                                              onTap: loadAssets,
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
                      ).whenComplete(() {
                        //Navigator.of(context).pop();
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (priceController.text.isNotEmpty &&
              titleController.text.isNotEmpty &&
              suburbController.text.isNotEmpty &&
              _province.isNotEmpty &&
              _city.isNotEmpty) {
            var price = double.parse(priceController.text.toString());
            Advert advert = Advert(
              roomType: _roomType,
              //prince: double.parse(priceController.text).toDouble(),
              price: price,
              title: titleController.text.toString(),
              decription: decriptionController.text.toString(),
              province: _province,
              city: _city,
              suburb: suburbController.text.toString(),
              userId: widget.idUser,
              status: 'pending',
            );
            FireBusinessApi.addAdvert(advert).then((result) {
              print(result.toString());

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPostsPage(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    contactNumber: widget.contactNumber,
                    email: widget.email,
                    idUser: widget.idUser,
                  ),
                ),
              );
            }).catchError((e) => print(e.toString));

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => CreatePostPart2(
            //       firstName: widget.firstName,
            //       lastName: widget.lastName,
            //       contactNumber: widget.contactNumber,
            //       email: widget.email,
            //       id: widget.id,
            //       authToken: widget.authToken,
            //       advert: advert,
            //     ),
            //   ),
            // );
          } else {
            Fluttertoast.showToast(
                backgroundColor: Colors.black38.withOpacity(0.8),
                msg:
                    'Some of your fields are empty, please make sure all required info are filed');
          }
        },
        child: Icon(
          Icons.check,
          color: Colors.white70,
        ),
        backgroundColor: MyColors.primaryColor,
      ),
    );
  }

  _uploadImageFromCamera() async {
    String error = 'No Error Detected';
    final _imagePicker = ImagePicker();
    PickedFile image;
    File file;
    try {
      //Check Permissions
      await Permission.photos.request();
      var permissionStatus = await Permission.photos.status;
      if (permissionStatus.isGranted) {
        //Select Image
        image = await _imagePicker.getImage(source: ImageSource.camera);
        file = File(image.path);
        print(file.path);
      } else {
        print('Permission not granted. Try again with permission access');
      }
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      //_error = error;
      //imageFiles.add(file);
    });
    //print(images.length);
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: 'Photos'),
        materialOptions: MaterialOptions(
          actionBarColor: '#FF30C6D1',
          actionBarTitle: 'eRoom App',
          allViewTitle: 'Room Images',
          useDetailsView: true,
          selectCircleStrokeColor: '#000000',
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() async {
      // _error = error;

      // fileConvert(resultList).then((result) {
      //   setState(() {
      //     imageFiles.addAll(result);
      //     isLoading = false;
      //   });
      // }).catchError((e) {});
    });
  }
}
