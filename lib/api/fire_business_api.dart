import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/models/advert_image.dart';
import 'package:eRoomApp/utils.dart';

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

  static Future addAdvert(Advert advert) async {
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
    }).then((result) {
      FirebaseFirestore.instance.collection('adverts').doc(result.id).update({
        'id': result.id,
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
      'updatedAt': advert.updatedAt,
      'status': advert.status,
    });
  }

  static Future addAdvertImage(AdvertImage advertImage) async {
    FirebaseFirestore.instance
        .collection('advertImages')
        .add({}).then((result) {
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

  static Stream<List<AdvertImage>> retrieveAdvertImages(String advertId) =>
      FirebaseFirestore.instance
          .collection('advertImages')
          .orderBy(AdvertImageField.createdAt, descending: true)
          .where('advertId', isEqualTo: advertId)
          .snapshots()
          .transform(Utils.transformer(AdvertImage.fromJson));
}
