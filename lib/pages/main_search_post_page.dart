import 'package:eRoomApp/api/business_api.dart';
import 'package:eRoomApp/models/static_data.dart';
import 'package:eRoomApp/pages/post_search_results_display.dart';
import 'package:eRoomApp/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:eRoomApp/theme.dart';

class MainSearchPostPage extends StatefulWidget {
  @override
  _MainSearchPostPageState createState() => _MainSearchPostPageState();
}

class _MainSearchPostPageState extends State<MainSearchPostPage> {
  TextEditingController suburbController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceControler = TextEditingController();

  bool isMenuOpen = false;
  String url = BusinessApi.url;
  String _city;

  // Future<void> makeRequest(
  //     {String minValue, String maxValue, String suburb, String city}) async {

  //   var response = await http.get(
  //     Uri.encodeFull(url +
  //         'adverts?min_value=' +
  //         minValue +
  //         '&max_value=' +
  //         maxValue +
  //         '&suburb=' +
  //         suburb +
  //         '&city=' +
  //         city),
  //     headers: {
  //       'Accept': 'application/json',
  //       'Authorization': widget.authToken,
  //     },
  //   );

  //   setState(() {
  //     var extractData = jsonDecode(response.body);
  //     adverts = extractData[1]['adverts'] as List;
  //     images = extractData[0]['images'] as List;
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    suburbController.dispose();
    maxPriceControler.dispose();
    minPriceController.dispose();
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
                                        hintStyle: new TextStyle(
                                            color: Colors.grey[800]),
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
                                print('Yeah: ' + _city);
                              });
                            },
                          ),
                        ),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostSearchResultsDisplay(
                minPrice: double.parse(minPriceController.text.toString()),
                maxPrice: double.parse(maxPriceControler.text.toString()),
                suburb: suburbController.text,
                city: _city,
              ),
            ),
          );
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
