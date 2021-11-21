import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/models/static_data.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/custom_textfield.dart';
import 'package:eRoomApp/widgets/dialog_box_post_confirm.dart';
import 'package:eRoomApp/widgets/post_ad_details_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostAdEdit extends StatefulWidget {
  final Advert advert;
  final String firstName;
  final String lastName;
  final String idUser;
  final String email;
  final String contactNumber;
  final bool isEnabled;

  PostAdEdit({
    @required this.advert,
    @required this.firstName,
    @required this.lastName,
    @required this.idUser,
    @required this.email,
    @required this.contactNumber,
    @required this.isEnabled,
  });
  @override
  _PostAdEditState createState() => _PostAdEditState();
}

class _PostAdEditState extends State<PostAdEdit> {
  bool isSwitched = false;

  String _province;
  String _city;
  String _roomType;
  String _status, _textStatus;
  Color _color;
  //List<Province> _cities = List<Province>();

  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController suburbController = TextEditingController();

  List<String> _roomTypesCottage = [
    'Select Room/Cottage',
    'Cottage',
    'Room',
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      print(widget.advert.status);
      if (widget.advert != null) {
        //if (widget.advert.status.contains('approved')) isSwitched = true;

        if (widget.advert.status.contains('approved')) {
          _textStatus = 'Post Active';
          _color = Color(0xFF26ED41);
        } else if (widget.advert.status.contains('pending')) {
          _textStatus = 'Post Pending';
          _color = Colors.amberAccent;
        } else {
          _textStatus = 'Post Active';
          _color = Colors.redAccent.shade200;
        }
      }

      priceController.text = widget.advert.price.toString();
      titleController.text = widget.advert.title;
      descriptionController.text = widget.advert.decription;
      cityController.text = widget.advert.city;
      suburbController.text = widget.advert.suburb;
      _roomType = widget.advert.roomType;
      _province = widget.advert.province;
    });
  }

  @override
  void dispose() {
    priceController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    cityController.dispose();
    suburbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white70),
        backgroundColor: MyColors.primaryColor,
        title: Text(
          'Details',
          style: TextStyle(
            fontSize: 22.0.sp,
            color: Colors.white70,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0.r),
            topRight: Radius.circular(30.0.r),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height.h,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            children: <Widget>[
                              PostAdDetailStatus(
                                  color: _color, textStatus: _textStatus),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Availability',
                                          style: TextStyle(
                                            fontSize: 16.0.sp,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        Switch(
                                          value: isSwitched,
                                          onChanged: widget.isEnabled
                                              ? (value) {
                                                  setState(() {
                                                    isSwitched = value;
                                                    print(isSwitched);
                                                    if (isSwitched) {
                                                      _status = 'pending';
                                                      _textStatus =
                                                          'Activating Post';
                                                      _color =
                                                          Color(0xFF26ED41);
                                                    } else {
                                                      _status = 'decined';
                                                      _textStatus =
                                                          'Closing Post';
                                                      _color = Colors
                                                          .redAccent.shade200;
                                                    }
                                                  });
                                                }
                                              : null,

                                          //inactiveThumbColor:
                                          //    MyColors.primaryColor,
                                          inactiveTrackColor:
                                              Colors.tealAccent.withOpacity(.5),
                                          activeColor: MyColors.primaryColor,
                                          activeTrackColor:
                                              MyColors.primaryColorLight,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0.w,
                                        vertical: 2.0.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade50,
                                        borderRadius:
                                            BorderRadius.circular(25.0.r),
                                      ),
                                      child: DropdownButton(
                                        dropdownColor: Colors.blueGrey[100],
                                        underline: SizedBox(),
                                        value: _roomType,
                                        hint: Text(
                                          'Select Room/Type',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 18.0.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        isExpanded: true,
                                        iconSize: 30.0.sp,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        items: _roomTypesCottage.map(
                                          (val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text(
                                                val,
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 18.0.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                        onChanged: widget.isEnabled
                                            ? (val) {
                                                setState(() {
                                                  _roomType = val;
                                                  print('Yeah: ' + _roomType);
                                                });
                                              }
                                            : null,
                                      ),
                                    ),
                                    CustomTextField(
                                      hintTxt: '4800.00',
                                      labelTxt: 'Price',
                                      icon: Icon(
                                        Icons.money_sharp,
                                        color: MyColors.primaryColor,
                                      ),
                                      controller: priceController,
                                      isReadOnly: widget.isEnabled,
                                    ),
                                    CustomTextField(
                                      hintTxt: 'Incredible room a bachelar',
                                      labelTxt: 'Title',
                                      icon: Icon(
                                        Icons.title,
                                        color: MyColors.primaryColor,
                                      ),
                                      controller: titleController,
                                      isReadOnly: widget.isEnabled,
                                    ),
                                    CustomTextField(
                                      hintTxt:
                                          'A stylish great room suitable for a stylish',
                                      labelTxt: 'Description',
                                      icon: Icon(
                                        Icons.description,
                                        color: MyColors.primaryColor,
                                      ),
                                      controller: descriptionController,
                                      isReadOnly: widget.isEnabled,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0.w,
                                        vertical: 2.0.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade50,
                                        borderRadius:
                                            BorderRadius.circular(25.0.r),
                                      ),
                                      child: DropdownButton(
                                        dropdownColor: Colors.blueGrey[100],
                                        underline: SizedBox(),
                                        value: _province,
                                        hint: Text(
                                          'Select Province',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 18.0.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        isExpanded: true,
                                        iconSize: 30.0.sp,
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
                                                  fontSize: 18.0.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                        onChanged: widget.isEnabled
                                            ? (val) {
                                                setState(() {
                                                  _province = val;
                                                  //_cities
                                                  //_cities = List<Province>();

                                                  /*ProvinceApi.getProvinces(_province)
                                                .then((citites) {
                                              _cities = citites;
                                              print(_cities);
                                            });*/
                                                });
                                              }
                                            : null,
                                      ),
                                    ),
                                    SizedBox(height: 10.0.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0.w,
                                        vertical: 2.0.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade50,
                                        borderRadius:
                                            BorderRadius.circular(25.0.r),
                                      ),
                                      child: DropdownButton(
                                        dropdownColor: Colors.blueGrey[100],
                                        underline: SizedBox(),
                                        isExpanded: true,
                                        iconSize: 30.0.sp,
                                        value: _city,
                                        hint: Text(
                                          'Select City',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 18.0.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        items: StaticData.cities.map((value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 18.0.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: widget.isEnabled
                                            ? (val) {
                                                setState(() {
                                                  this._city = val;
                                                  print('City: $_city');
                                                });
                                              }
                                            : null,
                                      ),
                                      /*child: 
                                      FutureBuilder(
                                        future:
                                            ProvinceApi.getProvinces(_province),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else {
                                            List<Province> provincies =
                                                snapshot.data;
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
                                              dropdownColor:
                                                  Colors.blueGrey[100],
                                              underline: SizedBox(),
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
                                              items: provincies.map((value) {
                                                return DropdownMenuItem<
                                                    dynamic>(
                                                  value: value.city,
                                                  child: Text(
                                                    value.city,
                                                    style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                      ),*/
                                    ),
                                    CustomTextField(
                                      hintTxt: 'Midrand',
                                      labelTxt: 'Suburb',
                                      icon: Icon(
                                        Icons.location_city,
                                        color: MyColors.primaryColor,
                                      ),
                                      controller: suburbController,
                                      isReadOnly: widget.isEnabled,
                                    ),
                                    SizedBox(height: 10.0.h),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: widget.isEnabled
          ? FloatingActionButton(
              onPressed: () {
                var price = double.parse(priceController.text.toString());
                Advert advert = new Advert(
                  roomType: _roomType,
                  price: price,
                  title: titleController.text.toString(),
                  decription: descriptionController.text.toString(),
                  province: _province,
                  city: cityController.text.toString(),
                  suburb: suburbController.text.toString(),
                  status: _status ?? 'pending',
                );

                FireBusinessApi.updateAdvert(advert, widget.advert.id)
                    .then((resut) {
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

                  Fluttertoast.showToast(
                    msg: 'Post updated.',
                    backgroundColor: Colors.black12.withOpacity(.7),
                    textColor: Colors.white,
                  );
                }).catchError(
                  (e) => Fluttertoast.showToast(
                    msg: 'Unable to update the post.',
                    backgroundColor: Colors.black12.withOpacity(.7),
                    textColor: Colors.white,
                  ),
                );

                dispose();
              },
              child: Icon(
                Icons.check,
                size: 30.0.sp,
                color: Colors.white70,
              ),
              backgroundColor: MyColors.primaryColor,
            )
          : SizedBox.shrink(),
    );
  }
}
