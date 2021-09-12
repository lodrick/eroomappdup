import 'dart:io';

import 'package:flutter/material.dart';

class AdvertImgWidget extends StatelessWidget {
  final List<File> imageFiles;

  AdvertImgWidget({@required this.imageFiles, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.black12,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.29,
              child: GridView.builder(
                itemCount: imageFiles.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300.0,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  
                  File imageFile = imageFiles[index];
                  
                  return Padding(
                    padding:
                        EdgeInsets.only(left: .0, top: 0, right: .0, bottom: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        
                        Expanded(
                          child: Container(
                            child: Image.file(
                              imageFile,
                              width: 500,
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  );
                  
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
