import 'dart:io';
import 'dart:typed_data';

import 'package:eRoomApp/api/fire_business_api.dart';
//import 'package:eRoomApp/api/province_api.dart';
import 'package:eRoomApp/models/advert.dart';
//import 'package:eRoomApp/models/province.dart';
import 'package:eRoomApp/models/static_data.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/custom_textfield.dart';
import 'package:eRoomApp/widgets/dialog_box_post_confirm.dart';
import 'package:eRoomApp/widgets/popover.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final formKey = GlobalKey<FormState>();
  List<File> imageFiles;
  String _province;
  String _roomType;
  String _city;

  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController decriptionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController suburbController = TextEditingController();

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
    Navigator.of(context).pop();
    String error = 'No Error Detected';
    final _imagePicker = ImagePicker();
    if (imageFiles == null) {
      imageFiles = [];
    }

    PickedFile image;

    File file;
    try {
      await Permission.photos.request();
      var permissionStatus = await Permission.photos.status;
      if (permissionStatus.isGranted) {
        image = await _imagePicker.getImage(source: ImageSource.camera);
        file = File(image.path);
        print(file.path);
        Uint8List fileBytes = file.readAsBytesSync();
        print('file byte Length ${fileBytes.length}');
      } else {
        print('Permission not granted. Try again with permission access');
      }
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }

    if (!mounted) return;

    setState(() {
      imageFiles.add(file);
    });
  }

  void filesPicker() async {
    Navigator.of(context).pop();
    if (imageFiles == null) {
      imageFiles = [];
    }
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
      body: Form(
        key: formKey,
        child: SafeArea(
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
                    //CustomDropdown(text: 'Call to nothing'),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: MyColors.textFieldColor,
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),
                      child: DropdownButtonFormField(
                        dropdownColor: Colors.white,
                        decoration: InputDecoration.collapsed(hintText: ''),
                        //underline: SizedBox(),
                        value: _roomType,
                        hint: Text(
                          'Select Room/Type',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        isExpanded: true,
                        iconSize: 30.0,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        validator: (value) =>
                            value == null ? 'Room/Type is required*' : null,
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
                      errorText: 'Please enter the correct price*',
                      textInputType: TextInputType.number,
                    ),
                    CustomTextField(
                      hintTxt: 'Incredible room a bachelar',
                      labelTxt: 'Title',
                      icon: Icon(
                        Icons.title,
                        color: MyColors.primaryColor,
                      ),
                      controller: titleController,
                      errorText: 'Please fill in the title*',
                      textInputType: TextInputType.text,
                    ),
                    CustomTextField(
                      hintTxt: 'A stylish great room suitable for a stylish',
                      labelTxt: 'Description',
                      icon: Icon(
                        Icons.description,
                        color: MyColors.primaryColor,
                      ),
                      controller: decriptionController,
                      errorText: 'Please fill in the description*',
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(height: 4.0),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: MyColors.textFieldColor,
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),
                      child: DropdownButtonFormField(
                        dropdownColor: Colors.white,
                        decoration: InputDecoration.collapsed(hintText: ''),
                        //underline: SizedBox(),
                        value: _province,
                        hint: Text(
                          'Select Province',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        isExpanded: true,
                        iconSize: 30.0,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        validator: (value) =>
                            value == null ? 'Province is required*' : null,
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
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: MyColors.textFieldColor,
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),
                      child: DropdownButtonFormField(
                        dropdownColor: Colors.blueGrey[100],
                        //underline: SizedBox(),
                        decoration: InputDecoration.collapsed(hintText: ''),
                        isExpanded: true,
                        iconSize: 30.0,
                        value: _city,
                        hint: Text(
                          'Select City',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        validator: (value) =>
                            value == null ? 'City is required*' : null,
                        items: StaticData.cities.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            this._city = val;
                            print('City: $_city');
                          });
                        },
                      ),
                    ),

                    /*Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: FutureBuilder(
                        future: ProvinceApi.getProvinces(_province),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            List<Province> provincies = snapshot.data;
                            if (provincies == null) {
                              provincies = List<Province>();
                              provincies.add(
                                new Province(
                                  city: 'Select your provice',
                                  lat: '-26.2044',
                                  lng: '28.0416',
                                  country: 'South Africa',
                                  iso2: 'ZA',
                                  adminName: 'Gauteng',
                                  capital: 'admin',
                                  population: '4434827',
                                  populationProper: '4434827',
                                ),
                              );
                            }
                            return DropdownButton(
                              dropdownColor: Colors.white,
                              underline: SizedBox(),
                              isExpanded: true,
                              iconSize: 30.0,
                              value: _city,
                              hint: Text(
                                'Select City',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              items: provincies.map((value) {
                                return DropdownMenuItem<dynamic>(
                                  value: value.city,
                                  child: Text(
                                    value.city,
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _city = val;
                                  print('City: $_city');
                                });
                              },
                            );
                          }
                        },
                      ),
                    ),*/
                    SizedBox(height: 4.0),
                    CustomTextField(
                      hintTxt: 'Midrand',
                      labelTxt: 'Suburb',
                      icon: Icon(
                        Icons.location_city,
                        color: MyColors.primaryColor,
                      ),
                      controller: suburbController,
                      errorText: 'Please fill in the suburb*',
                      textInputType: TextInputType.streetAddress,
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
                                        onTap: () => Navigator.of(context)
                                            .pop(), // Closing the sheet.
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
                                                onTap: filePicker,
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.photo_camera,
                                                    color:
                                                        MyColors.primaryColor,
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
                                                onTap: filesPicker,
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.photo_album,
                                                    color:
                                                        MyColors.primaryColor,
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
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          imageFiles != null
                              ? Container(
                                  height: 70.0,
                                  padding: EdgeInsets.all(1.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.grey[800],
                                          Colors.white,
                                        ]),
                                  ),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imageFiles != null
                                        ? imageFiles.length
                                        : 0,
                                    itemBuilder: (context, index) {
                                      final imageFile = imageFiles[index];
                                      if (imageFiles.length <= 0) {
                                        return SizedBox.shrink();
                                      } else {
                                        return Container(
                                          padding: EdgeInsets.only(right: 5.0),
                                          margin: EdgeInsets.only(right: 5.0),
                                          width: 75.0,
                                          child: IconButton(
                                            splashColor: MyColors.primaryColor,
                                            icon: Icon(
                                              Icons.cancel_outlined,
                                              size: 40,
                                              color: Colors.black54,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                imageFiles.removeAt(imageFiles
                                                    .indexOf(imageFile));
                                              });
                                            },
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                              image: FileImage(imageFile),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.blueGrey,
        onPressed: () {
          if (formKey.currentState.validate()) {
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
                email: widget.email,
                status: 'pending',
              );
              FireBusinessApi.addAdvert(advert, imageFiles).then((result) {
                showDialog(
                  context: context,
                  builder: (context) => DialogBoxPost(
                    title: advert.title,
                    descrition:
                        'Your post is under review, you will receive an email when it has been declined or approved',
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    contactNumber: widget.contactNumber,
                    idUser: widget.idUser,
                  ),
                );
              }).catchError((e) => print(e.toString));
            } else {
              Fluttertoast.showToast(
                  backgroundColor: Colors.black38.withOpacity(0.8),
                  msg: 'Aleast 1 Image is required.');
            }
          } else {
            Fluttertoast.showToast(
                backgroundColor: Colors.black38.withOpacity(0.8),
                msg: 'Please upload aleast one image');
          }
          /*Fluttertoast.showToast(
              backgroundColor: Colors.black38.withOpacity(0.8),
              msg: 'Submitting.');
          print('submitting');*/

          /*if (priceController.text.isNotEmpty &&
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
                email: widget.email,
                status: 'pending',
              );

              FireBusinessApi.addAdvert(advert, imageFiles).then((result) {
                showDialog(
                  context: context,
                  builder: (context) => DialogBoxPost(
                    title: advert.title,
                    descrition:
                        'Your post is under review, you will receive an email when it has been declined or approved',
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    contactNumber: widget.contactNumber,
                    idUser: widget.idUser,
                  ),
                );
              }).catchError((e) => print(e.toString));
            } else {
              Fluttertoast.showToast(
                  backgroundColor: Colors.black38.withOpacity(0.8),
                  msg: 'Aleast 1 Image is required.');
            }
          } else {
            Fluttertoast.showToast(
                backgroundColor: Colors.black38.withOpacity(0.8),
                msg:
                    'Some of your fields are empty, please make sure all required info are filed');
          }*/
        },
        child: Icon(
          Icons.check,
          color: Colors.white70,
        ),
        backgroundColor: MyColors.primaryColor,
      ),
    );
  }
}
