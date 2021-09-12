import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/utils.dart';

class FireBusinessApi {
  static Stream<List<Advert>> getAdverts() => FirebaseFirestore.instance
      .collection('adverts')
      .orderBy(AdvertField.updatedAt, descending: true)
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
}
