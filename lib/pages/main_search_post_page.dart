import 'package:eRoomApp/api/business_api.dart';
import 'package:eRoomApp/api/province_api.dart';
//import 'package:eRoomApp/models/province.dart';
import 'package:eRoomApp/models/static_data.dart';
import 'package:eRoomApp/pages/post_search_results_display.dart';
import 'package:eRoomApp/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:eRoomApp/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class MainSearchPostPage extends StatefulWidget {
  final String contactNumber;
  MainSearchPostPage({
    @required this.contactNumber,
    Key key,
  }) : super(key: key);

  @override
  _MainSearchPostPageState createState() => _MainSearchPostPageState();
}

class _MainSearchPostPageState extends State<MainSearchPostPage> {
  TextEditingController suburbController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceControler = TextEditingController();

  bool isMenuOpen = false;
  String url = BusinessApi.url;
  String _province;
  String _city;

  @override
  void dispose() {
    super.dispose();
    suburbController.dispose();
    maxPriceControler.dispose();
    minPriceController.dispose();
    ProvinceApi.getProvinces('Gauteng');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 30.0),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            'Price Range',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'OpenSans',
                              color: Colors.blueGrey[600],
                              fontWeight: FontWeight.w400,
                              shadows: [
                                Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(2.0, 4.0),
                                    blurRadius: 10.0),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFF8E1),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: TextFormField(
                                      controller: minPriceController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5.0,
                                        ),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Icon(
                                            Icons.location_pin,
                                            color: MyColors.primaryColor,
                                          ),
                                        ),
                                        filled: false,
                                        /*hintStyle: new TextStyle(
                                          color: Colors.grey[800],
                                        ),*/
                                        hintStyle: GoogleFonts.lato(
                                            color: Colors.grey[700]),
                                        hintText: 'R1',
                                        labelText: 'Min',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFF8E1),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: TextFormField(
                                      controller: maxPriceControler,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5.0,
                                        ),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Icon(
                                            Icons.location_pin,
                                            color: MyColors.primaryColor,
                                          ),
                                        ),
                                        filled: false,
                                        hintStyle: new TextStyle(
                                            color: Colors.grey[800]),
                                        hintText: 'R500',
                                        labelText: 'Max',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 2.0),
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
                                print('_province $_province');
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: DropdownButton(
                            dropdownColor: Colors.blueGrey[100],
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: FutureBuilder(
                            future: ProvinceApi.getProvinces(_province),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
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
                                    return DropdownMenuItem<String>(
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
                                      print('_City: $_city');
                                    });
                                  },
                                );
                              }
                            },
                          ),
                        ),*/
                        SizedBox(
                          height: 4.0,
                        ),
                        CustomTextField(
                          controller: suburbController,
                          hintTxt: 'Centurion',
                          labelTxt: 'Suburb',
                          icon: Icon(
                            Icons.location_city,
                            color: MyColors.primaryColor,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (minPriceController.text.isNotEmpty &&
              maxPriceControler.text.isNotEmpty &&
              suburbController.text.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostSearchResultsDisplay(
                  minPrice: double.parse(minPriceController.text.toString()),
                  maxPrice: double.parse(maxPriceControler.text.toString()),
                  suburb: suburbController.text,
                  contactNumber: widget.contactNumber,
                  city: _city,
                ),
              ),
            );
          } else {
            Fluttertoast.showToast(
                backgroundColor: Colors.black38.withOpacity(0.8),
                msg:
                    'Some of your fields are empty, please make sure all required info are field.');
          }
        },
        child: Icon(
          Icons.search,
          color: Colors.white70,
        ),
        backgroundColor: MyColors.primaryColor,
      ),
    );
  }
}
