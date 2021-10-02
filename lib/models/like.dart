class Like {
  final String idLike;
  final String idUser;
  final String idAd;
  final bool like;

  Like({
    this.idLike,
    this.idUser,
    this.idAd,
    this.like,
  });

  Like copyWith({
    final String idLike,
    final String idUser,
    final String idAd,
    final bool like,
  }) =>
      Like(
          idLike: idLike ?? this.idLike,
          idUser: idUser ?? this.idUser,
          idAd: idAd ?? this.idAd,
          like: like ?? this.like);

  static Like fromJson(Map<String, dynamic> json) => Like(
        idLike: json['idLike'],
        idUser: json['idUser'],
        idAd: json['idAd'],
        like: json['like'],
      );

  Map<String, dynamic> toJson() => {
        'idLike': idLike,
        'idUser': idUser,
        'idAd': idAd,
        'like': like,
      };
}
