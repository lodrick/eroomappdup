import 'dart:io';

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

  static Future addAdvert(Advert advert, List<String> paths) async {
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
      //'uriImages': advert.uriImages,
    }).then((advert) {
      for (String path in paths) {
        getAdvertImageUrl(path).then((path) {
          AdvertImage advertImage =
              AdvertImage(advertId: advert.id, imageUrl: path);
          addAdvertImage(advertImage).then((advertImage) {
            print(advertImage.toString());
          }).catchError((e) => print(e.toString()));
        }).catchError((e) => print(e.toString()));
      }

      FirebaseFirestore.instance.collection('adverts').doc(advert.id).update({
        'id': advert.id,
      }).then((res) {
        print('Success');
      });
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

  static Future<String> getAdvertImageUrl(path) async {
    String fileName = path.split('/').last;
    var file = await File(path).create();
    var downLoadUrl;
    if (path.isNotEmpty) {
      print('path is not empty');
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('advertImages/${Path.basename(fileName)}')
          .putFile(file);
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
