import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';

class DropdownSelector extends StatefulWidget {
  final List<String> items;

  final String selectOption;
  DropdownSelector({this.items, this.selectOption});

  @override
  _DropdownSelectorState createState() => _DropdownSelectorState();
}

class _DropdownSelectorState extends State<DropdownSelector> {
  String _dropDownValue = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton(
        dropdownColor: MyColors.primaryColor,
        underline: SizedBox(),
        value: _dropDownValue,
        hint: Text(
          widget.selectOption,
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
        items: widget.items.map(
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
            _dropDownValue = val;
          });
        },
      ),
    );
  }
}
