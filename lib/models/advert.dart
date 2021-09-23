import 'package:eRoomApp/models/advert_image.dart';

class AdvertField {
  static final String updatedAt = 'updatedAt';
}

class Advert {
  final String id;
  final String roomType;
  final double price;
  final String title;
  final String decription;
  final String province;
  final String city;
  final String suburb;
  final String userId;
  final createdAt;
  final updatedAt;
  final bool liked;
  final String status;
  final String advertUrl;
  final List<AdvertImage> advertImages;

  Advert({
    this.id,
    this.roomType,
    this.price,
    this.title,
    this.decription,
    this.province,
    this.city,
    this.suburb,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.liked,
    this.advertUrl,
    this.advertImages,
    this.status,
  });

  Advert copyWith({
    String id,
    String roomType,
    double price,
    String title,
    String decription,
    String province,
    String city,
    String suburb,
    String userId,
    String createdAt,
    String updatedAt,
    String status,
    String advertUrl,
    List<AdvertImage> advertImages,
  }) =>
      Advert(
        id: id ?? this.id,
        roomType: roomType ?? this.roomType,
        price: price ?? this.price,
        title: title ?? this.title,
        decription: decription ?? this.decription,
        province: province ?? this.province,
        city: city ?? this.city,
        suburb: suburb ?? this.suburb,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
        advertUrl: advertUrl ?? this.advertUrl,
        advertImages: advertImages ?? this.advertImages,
      );

  // factory Advert.fromJson(Map<String, dynamic> json) => Advert(
  //       id: json['id'] as String,
  //       roomType: json['room_type'] as String,
  //       price: json['price'] as double,
  //       title: json['title'] as String,
  //       decription: json['description'] as String,
  //       city: json['city'] as String,
  //       suburb: json['suburb'] as String,
  //       userId: json['user_id'] as String,
  //       createdAt: json['created_at'] as String,
  //       updatedAt: json['updated_at'] as String,
  //       status: json['status'] as String,
  //       images: json['images'] as List<Asset>,
  //       //for(AdvertImage advertImage in advertImages ){}
  //     );
  static Advert fromJson(Map<String, dynamic> json) => Advert(
        id: json['id'],
        roomType: json['roomType'],
        price: json['price'],
        title: json['title'],
        decription: json['description'],
        city: json['city'],
        suburb: json['suburb'],
        userId: json['userId'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        liked: json['liked'],
        status: json['status'],
        advertUrl: json['advertUrl'],
      );

  // fromJS({Map<String, dynamic> json, List<AdvertImage> advertImagess}) {
  //   id = json['id'];
  //   roomType = json['roomType'];
  //   price = json['price'];
  //   title = json['title'];
  //   decription = json['description'];
  //   city = json['city'];
  //   suburb = json['suburb'];
  //   userId = json['user_id'];
  //   createdAt = json['createdAt'];
  //   updatedAt = json['updatedAt'];
  //   status = json['status'];
  //   images = json['images'];
  // }

  Map<String, dynamic> toJson() => {
        'id': id,
        'roomType': roomType,
        'price': price,
        'title': title,
        'description': decription,
        'province': province,
        'city': city,
        'suburb': suburb,
        'userId': userId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'status': status,
        'advertUrl': advertUrl
        //'uriImages': uriImages,
      };
}
