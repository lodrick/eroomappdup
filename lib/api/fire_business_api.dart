import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/models/advert_image.dart';
import 'package:eRoomApp/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class FireBusinessApi {
  static Stream<List<Advert>> getAdverts() => FirebaseFirestore.instance
      .collection('adverts')
      .orderBy(AdvertField.updatedAt, descending: true)
      .snapshots()
      .transform(Utils.transformer(Advert.fromJson));

  static Stream<List<Advert>> getFavouriteAdvert(String idUser, bool liked) =>
      FirebaseFirestore.instance
          .collection('adverts')
          .orderBy(AdvertField.updatedAt, descending: true)
          .where('userId', isEqualTo: idUser)
          .where('liked', isEqualTo: true)
          .snapshots()
          .transform(Utils.transformer(Advert.fromJson));

  static Stream<List<Advert>> getMyAdverts(String idUser) =>
      FirebaseFirestore.instance
          .collection('adverts')
          .orderBy(AdvertField.updatedAt, descending: true)
          .where('userId', isEqualTo: idUser)
          .snapshots()
          .transform(Utils.transformer(Advert.fromJson));

  static Stream<List<Advert>> getSearchResultAdvert(
          double minprice, double maxPrice, String suburb, String city) =>
      FirebaseFirestore.instance
          .collection('adverts')
          .orderBy(AdvertField.updatedAt, descending: true)
          .where('price', isGreaterThan: maxPrice)
          .where('price', isLessThan: minprice)
          .where('suburb', isEqualTo: suburb)
          .where('city', isEqualTo: city)
          .snapshots()
          .transform(Utils.transformer(Advert.fromJson));

  static Future addAdvert(Advert advert, List<File> files) async {
    FirebaseFirestore.instance.collection('adverts').add({
      'id': advert.id,
      'roomType': advert.roomType,
      'price': advert.price,
      'title': advert.title,
      'description': advert.decription,
      'province': advert.province,
      'city': advert.city,
      'suburb': advert.suburb,
      'userId': advert.userId,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'status': advert.status,
    }).then((advert) {
      List<String> urlImages = List<String>();

      for (File file in files) {
        getAdvertImageUrl(file).then((path) {
          print(path);
          urlImages.add(path);
          FirebaseFirestore.instance
              .collection('adverts')
              .doc(advert.id)
              .update(
                Advert.adPhotos(id: advert.id, photoUrl: path),
              )
              .then((res) {})
              .catchError((e) => print(e.toString()));
        }).catchError((e) => print(e.toString()));
      }
    });
  }

  static Future updateAdvert(Advert advert, adId) async {
    FirebaseFirestore.instance.collection('adverts').doc(adId).update({
      'id': advert.id,
      'roomType': advert.roomType,
      'price': advert.price,
      'title': advert.title,
      'description': advert.decription,
      'province': advert.province,
      'city': advert.city,
      'suburb': advert.suburb,
      'userId': advert.userId,
      'createdAt': advert.createdAt,
      'updatedAt': DateTime.now(),
      'status': advert.status,
    });
  }

  static Future addAdvertImage(AdvertImage advertImage) async {
    FirebaseFirestore.instance.collection('advertImages').add({
      'advertId': advertImage.advertId,
      'imageUrl': advertImage.imageUrl,
    }).then((result) {
      FirebaseFirestore.instance
          .collection('advertImages')
          .doc(result.id)
          .update({
        'imageId': result.id,
      }).then((res) {
        print('Success');
      });
    }).catchError((e) => print(e.toString()));
  }

  static Future<String> getAdvertImageUrl(File file) async {
    String fileName = Path.basename(file.path);
    //var file = await File(path).create();
    var downLoadUrl;
    if (file != null) {
      Uint8List fileByte = file.readAsBytesSync();
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('advertImages/$fileName')
          //.putFile(file);
          .putData(fileByte);
      downLoadUrl = await snapshot.ref.getDownloadURL();
    } else {
      print('No Image Path Received');
    }
    return downLoadUrl;
  }

  static Stream<List<AdvertImage>> retrieveAdvertImages(String advertId) =>
      FirebaseFirestore.instance
          .collection('advertImages')
          .orderBy(AdvertImageField.createdAt, descending: true)
          .where('advertId', isEqualTo: advertId)
          .snapshots()
          .transform(Utils.transformer(AdvertImage.fromJson));
}
