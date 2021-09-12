class PostLike {
  final String baseId;
  final String adId;
  final String currentUserId;
  final bool like;

  PostLike({this.baseId, this.adId, this.like, this.currentUserId});

  static PostLike fromJson(Map<String, dynamic> json) => PostLike(
        baseId: json['baseId'],
        adId: json['adId'],
        currentUserId: json['currentUserId'],
        like: json['like'],
      );
}
