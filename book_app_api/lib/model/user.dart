import 'dart:convert';

import 'package:book_app_api/dao/dao_entity.dart';

class User implements DaoEntity {
  int code;
  String? name;
  String? username;
  String? password;

  User({
    required this.code,
    required name,
    required username,
    required password,
  });

  User.empty()
      : this(
          code: DaoEntity.idInvalid,
          name: '',
          username: '',
          password: '',
        );

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      code: map['code'] as int? ?? DaoEntity.idInvalid,
      name: map['name'],
      username: map['username'],
      password: map['password'],
    );
  }

  @override
  void fromMap(Map<String, Object?> map) {
    code = map['code'] as int;
    name = map['name'] as String?;
    username = map['username'] as String?;
    password = map['password'] as String?;
  }

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'code': code,
      'name': name,
      'username': username,
      'password': password,
    };
    return map;
  }

  String toJson() => jsonEncode(toMap());
  factory User.fromJson(String json) => User.fromMap(jsonDecode(json));

  @override
  // TODO: implement id
  int get id => code;
}
