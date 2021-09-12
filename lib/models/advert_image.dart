class AdvertImage {
  final String imageId;
  final String advertId;
  final String imageUrl;

  AdvertImage({this.imageId, this.advertId, this.imageUrl});

  static AdvertImage fromJson(Map<String, dynamic> json) => AdvertImage(
        imageId: json['image_id'],
        advertId: json['advert_id'],
        imageUrl: json['image_url'],
      );

  Map<String, dynamic> toJson() => {
        'advert_id': imageId,
        'image_id': advertId,
        'image_url': imageUrl,
      };
}
