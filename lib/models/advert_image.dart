class AdvertImageField {
  static final String createdAt = 'lastMessageTime';
}

class AdvertImage {
  final String imageId;
  final String advertId;
  final String imageUrl;
  final createAt;

  AdvertImage({
    this.imageId,
    this.advertId,
    this.imageUrl,
    this.createAt,
  });

  AdvertImage copyWith({
    String imageId,
    String advertId,
    String imageUrl,
    String createdAt,
  }) =>
      AdvertImage(
        imageId: imageId ?? this.imageId,
        advertId: advertId ?? this.advertId,
        imageUrl: imageUrl ?? this.imageUrl,
        createAt: createAt ?? this.createAt,
      );

  static AdvertImage fromJson(Map<String, dynamic> json) => AdvertImage(
        imageId: json['imageId'],
        advertId: json['advertId'],
        imageUrl: json['imageUrl'],
        createAt: json['createdAt'],
      );

  Map<String, dynamic> toJson() => {
        'advert_id': imageId,
        'image_id': advertId,
        'image_url': imageUrl,
        'createdAt': createAt,
      };
}
