import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/pages/main_posts_page.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/custom_textfield.dart';
import 'package:eRoomApp/widgets/post_ad_details_stats.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostAdEdit extends StatefulWidget {
  final Advert advert;
  //final String authToken;
  final String firstName;
  final String lastName;
  final String idUser;
  final String email;
  final String contactNumber;

  PostAdEdit({
    @required this.advert,
    //@required this.authToken,
    @required this.firstName,
    @required this.lastName,
    @required this.idUser,
    @required this.email,
    @required this.contactNumber,
  });
  @override
  _PostAdEditState createState() => _PostAdEditState();
}

class _PostAdEditState extends State<PostAdEdit> {
  bool isSwitched = false;

  String _province;
  String _roomType;

  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController suburbController = TextEditingController();

  List<String> _roomTypesCottage = [
    'Select Room/Cattage',
    'Cattage',
    'Room',
  ];
  List<String> _provinces = [
    'Gauteng',
    'KwaZulu-Natal',
    'Eastern Cape',
    'Free State',
    'Limpopo',
    'Mpumalanga',
    'Northern Cape',
    'North West',
    'Western Cape'
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      print(widget.advert.status);
      if (widget.advert != null && widget.advert.status == 'active')
        isSwitched = true;

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
            fontSize: 22.0,
            color: Colors.white70,
          ),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, left: 0.0, right: 0.0),
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              isSwitched == true
                                  ? PostAdDetailStatus(
                                      color: Color(0xFF26ED41),
                                      textStatus: 'post is approved',
                                    )
                                  : PostAdDetailStatus(
                                      color: Colors.amber,
                                      textStatus: 'post is pedding',
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Availability',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.blueGrey),
                                        ),
                                        Switch(
                                          value: isSwitched,
                                          onChanged: (value) {
                                            setState(() {
                                              isSwitched = value;
                                              print(isSwitched);
                                            });
                                          },
                                          activeColor: MyColors.primaryColor,
                                          activeTrackColor:
                                              MyColors.primaryColorLight,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 2.0),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade50,
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      child: DropdownButton(
                                        dropdownColor: Colors.blueGrey[100]
                                            .withOpacity(0.6),
                                        underline: SizedBox(),
                                        value: _roomType,
                                        hint: Text(
                                          'Seelect Room/Type',
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
                                        items: _roomTypesCottage.map(
                                          (val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text(
                                                val,
                                                style: TextStyle(
                                                  color: Colors.black54,
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
                                    CustomTextField(
                                      hintTxt: '4800.00',
                                      labelTxt: 'Price',
                                      icon: Icon(
                                        Icons.money_sharp,
                                        color: MyColors.primaryColor,
                                      ),
                                      controller: priceController,
                                      //initialValue:
                                      //    'widget.advert.price.toString()',
                                    ),
                                    CustomTextField(
                                      hintTxt: 'Incredible room a bachelar',
                                      labelTxt: 'Title',
                                      icon: Icon(
                                        Icons.title,
                                        color: MyColors.primaryColor,
                                      ),
                                      controller: titleController,
                                      //initialValue: widget.advert.title,
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
                                      //initialValue: widget.advert.decription,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 2.0),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade50,
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      child: DropdownButton(
                                        dropdownColor: MyColors.primaryColor,
                                        underline: SizedBox(),
                                        value: _province,
                                        hint: Text(
                                          'Select Country',
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
                                        items: _provinces.map(
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
                                            _province = val;
                                            print('Yeah: ' + _province);
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    CustomTextField(
                                      hintTxt: 'Johannesburg',
                                      labelTxt: 'City',
                                      icon: Icon(
                                        Icons.location_city,
                                        color: MyColors.primaryColor,
                                      ),
                                      controller: cityController,
                                      //initialValue: widget.advert.city,
                                    ),
                                    CustomTextField(
                                      hintTxt: 'Midrand',
                                      labelTxt: 'Suburb',
                                      icon: Icon(
                                        Icons.location_city,
                                        color: MyColors.primaryColor,
                                      ),
                                      controller: suburbController,
                                      //initialValue: widget.advert.suburb,
                                    ),
                                    SizedBox(height: 10.0),
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
            status: 'pending',
          );

          FireBusinessApi.updateAdvert(advert, widget.advert.id).then((resut) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MainPostsPage(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    contactNumber: widget.contactNumber,
                    //authToken: widget.authToken,
                    email: widget.email,
                    idUser: widget.idUser,
                  ),
                ),
                (Route<dynamic> route) => false);
          }).catchError((e) => Fluttertoast.showToast(
              msg: 'Unable to update the post.',
              backgroundColor: MyColors.primaryColor,
              textColor: Colors.white));

          /*BusinessApi.updateAdvert(advert, widget.advert.id, widget.authToken)
              .then((result) {
            if (result == 200) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MainPostsPage(
                      firstName: widget.firstName,
                      lastName: widget.lastName,
                      contactNumber: widget.contactNumber,
                      //authToken: widget.authToken,
                      email: widget.email,
                      id: widget.id,
                    ),
                  ),
                  (Route<dynamic> route) => false);
            } else {
              Fluttertoast.showToast(
                  msg: 'Unable to update the post.',
                  backgroundColor: MyColors.primaryColor,
                  textColor: Colors.white);
            }
          }).catchError((error) {
            print(error.toString());
          });*/
          dispose();
        },
        child: Icon(
          Icons.check,
          size: 30.0,
          color: Colors.white70,
        ),
        backgroundColor: MyColors.primaryColor,
      ),
    );
  }
}
