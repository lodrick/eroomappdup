import 'package:eRoomApp/utils.dart';
import 'package:meta/meta.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String idUser;
  @required
  final String name;
  @required
  final String surname;
  @required
  final String email;
  final String password;
  final String passwordConf;
  final String country;
  @required
  final String contactNumber;
  @required
  final String userType;
  @required
  final String imageUrl;
  @required
  final lastMessageTime;
  final String token;

  User(
      {this.idUser,
      this.name,
      this.surname,
      this.email,
      this.password,
      this.passwordConf,
      this.country,
      this.contactNumber,
      this.userType,
      this.imageUrl,
      this.lastMessageTime,
      this.token});

  User copyWith({
    String idUser,
    String name,
    String surname,
    String email,
    String password,
    String passwordConf,
    String country,
    String contactNumber,
    String userType,
    String imageUrl,
    String lastMessageTime,
    String token,
  }) =>
      User(
        idUser: idUser ?? this.idUser,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        password: password ?? this.password,
        passwordConf: passwordConf ?? this.passwordConf,
        country: country ?? this.country,
        contactNumber: contactNumber ?? this.contactNumber,
        userType: userType ?? this.userType,
        imageUrl: imageUrl ?? this.imageUrl,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
        token: token ?? this.token,
      );

  static User fromJson(Map<String, dynamic> json) => User(
        idUser: json['idUser'],
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        password: json['password'],
        passwordConf: json['passwordConf'],
        country: json['country'],
        contactNumber: json['contactNumber'],
        userType: json['userType'],
        imageUrl: json['imageUrl'],
        lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'surname': surname,
        'email': email,
        'password': password,
        'passwordConf': passwordConf,
        'country': country,
        'contactNumber': contactNumber,
        'userType': userType,
        'imageUrl': imageUrl,
        'lastMessageTime': lastMessageTime,
        'token': token,
      };

  /*factory User.fromJson(final json) {
    return User(
      token: json['token'],
    );
  }*/
}
