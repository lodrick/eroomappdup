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
          //.orderBy(AdvertField.updatedAt, descending: true)
          .where('userId', isEqualTo: idUser)
          .snapshots()
          .transform(Utils.transformer(Advert.fromJson));

  static Stream<List<Advert>> getSearchResultAdvert(
          double minprice, double maxPrice, String suburb, String city) =>
      FirebaseFirestore.instance
          .collection('adverts')
          .where('price', isGreaterThan: minprice)
          .where('price', isLessThan: maxPrice)
          .where('suburb', isEqualTo: suburb)
          .where('status', isEqualTo: 'approved')
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
      'email': advert.email,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'status': advert.status,
      'likes': FieldValue.arrayUnion([])
    }).then((advertRuslt) {
      List<String> urlImages = List<String>();

      for (File file in files) {
        getAdvertImageUrl(file: file, userId: advert.userId).then((path) {
          print(path);
          urlImages.add(path);
          FirebaseFirestore.instance
              .collection('adverts')
              .doc(advertRuslt.id)
              .update(Advert.adPhotos(id: advertRuslt.id, photoUrl: path))
              .then((res) {})
              .catchError((e) => print(e.toString()));
        }).catchError((e) => print(e.toString()));
      }
      //removeLikes(idAd: advertRuslt.id, idUser: advert.userId);

      updateLikes(idAd: advertRuslt.id, idUser: advert.userId, like: false);
    });
  }

  static Future updateAdvert(Advert advert, adId) async {
    FirebaseFirestore.instance.collection('adverts').doc(adId).update({
      //'id': advert.id,
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

  static Future<String> getAdvertImageUrl({File file, String userId}) async {
    String fileName = Path.basename(file.path);
    var downLoadUrl;
    if (file != null) {
      Uint8List fileByte = file.readAsBytesSync();
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('advertImages/$userId/$fileName')
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

  static Future<void> updateLikes(
      {String idAd, String idUser, bool like}) async {
    FirebaseFirestore.instance
        .collection('adverts')
        .doc(idAd)
        .update(Advert.updateLike(idUser: idUser, like: like))
        .then((result) {})
        .catchError((e) => print(e.toString()));
  }

  static Future<void> removeLikes(
      {String idAd, String idUser, bool like}) async {
    FirebaseFirestore.instance.collection('adverts').doc(idAd).update(
        
        Advert.removeLike(idUser: idUser, like: like)).then((result) {
      print('Item removed');
    }).catchError((e) => print(e.toString()));
  }

  static Stream<List<Advert>> getFavAdverts(List<String> advertsIds) async* {
    List<Advert> adverts = List<Advert>();
    QueryDocumentSnapshot documentSnapshot;

    for (String advertsId in advertsIds) {
      var result = await FirebaseFirestore.instance
          .collection('adverts')
          .where('id', isEqualTo: advertsId)
          .get();
      result.docs.forEach((res) {
        documentSnapshot = res;
      });
      if (documentSnapshot != null) {
        adverts.add(Advert.fromJson(documentSnapshot.data()));
      }
    }

    yield adverts;
  }
}
