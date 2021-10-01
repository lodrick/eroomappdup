import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/models/static_data.dart';
import 'package:eRoomApp/pages/main_posts_page.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/custom_textfield.dart';
import 'package:eRoomApp/widgets/popover.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:multi_image_picker/multi_image_picker.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';

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
  List<File> imageFiles;
  String _province;
  String _roomType;
  String _city;

  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController decriptionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController suburbController = TextEditingController();
  //List<Asset> images = <Asset>[];

  @override
  void initState() {
    super.initState();
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

  void filePicker() async {
    String error = 'No Error Detected';
    final _imagePicker = ImagePicker();
    imageFiles = List<File>();
    PickedFile image;

    File file;
    try {
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
      imageFiles.add(file);
    });
  }

  void filesPicker() async {
    imageFiles = List<File>();
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
      for (File file in files) {
        Uint8List fileBytes = file.readAsBytesSync();
        print('file byte Length ${fileBytes.length}');
      }

      setState(() {
        imageFiles.addAll(files);
      });
    }
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
                                              //onTap: _uploadImageFromCamera,
                                              onTap: filePicker,
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
                                              //onTap: loadAssets,
                                              onTap: filesPicker,
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
          print("beae");

          if (priceController.text.isNotEmpty &&
              titleController.text.isNotEmpty &&
              suburbController.text.isNotEmpty &&
              _province.isNotEmpty &&
              _city.isNotEmpty) {
            var price = double.parse(priceController.text.toString());

            if (imageFiles != null && imageFiles.length > 0) {
              Advert advert = Advert(
                roomType: _roomType,
                price: price,
                title: titleController.text.toString(),
                decription: decriptionController.text.toString(),
                province: _province,
                city: _city,
                suburb: suburbController.text.toString(),
                userId: widget.idUser,
                status: 'pending',
                //advertUrl: imageUrls.first,
              );

              FireBusinessApi.addAdvert(advert, imageFiles).then((result) {
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
            } else {
              Fluttertoast.showToast(
                  backgroundColor: Colors.black38.withOpacity(0.8),
                  msg: 'Aleast 1 Image is required.');
            }

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

  /*_uploadImageFromCamera() async {
    String error = 'No Error Detected';
    final _imagePicker = ImagePicker();
    imageFiles = List<File>();
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
      imageFiles.add(file);
    });
    print(images.length);
  }*/

  /*Future<void> loadAssets() async {
    List<Asset> multiImgsPicked = <Asset>[];
    imageFiles = List<File>();
    String error = 'No Error Detected';
    try {
      print('please');
      multiImgsPicked = await MultiImagePicker.pickImages(
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
      print('error ' + error);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      // _error = error;
      fileConvert(multiImgsPicked);
    });
  }

  Future fileConvert(List<Asset> resultList) async {
    for (Asset asset in resultList) {
      final tempImageFile =
          File("${(await getTemporaryDirectory()).path}/${asset.name}");
      imageFiles.add(tempImageFile);
      print(tempImageFile.path);
    }
  }*/
}
