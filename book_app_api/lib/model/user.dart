import 'dart:convert';

import 'package:book_app_api/dao/dao_entity.dart';

class User implements DaoEntity {
  int? code;
  String? name;
  String? username;
  String? password;
  String? createdAt;

  User({
    required this.code,
    required this.name,
    required this.username,
    required this.password,
    required this.createdAt,
  });

  User.empty()
      : this(
          code: DaoEntity.idInvalid,
          name: '',
          username: '',
          password: '',
          createdAt: DaoEntity.dateInvalid,
        );

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      code: map['code'] as int? ?? DaoEntity.idInvalid,
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      createdAt: map['createdat'] ?? '',
    );
  }

  @override
  int get id => code!;

  @override
  void fromMap(Map<String, Object?> map) {
    code = map['code'] as int;
    name = map['name'] as String;
    username = map['username'] as String;
    password = map['password'] as String;
    createdAt = map['createdat'] as String;
    //print(
    //'Debug fromMap - code: $code, name: $name, username: $username, password: $password, createdAt: $createdAt');
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'username': username,
      'password': password,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toMapWithoutNulls() {
    final map = toMap();
    return map..removeWhere((key, value) => value == null);
  }

  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
