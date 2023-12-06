import 'dart:convert';

import 'package:book_app_api/dao/dao_entity.dart';

class Book implements DaoEntity {
  int? code;
  String? title;
  String? author;
  String? gender;
  String? createdAt;
  String? imageUrl;
  String? sinopse;
  String? linkReference;
  int? codeUser;

  Book({
    required this.code,
    this.title,
    this.author,
    this.gender,
    this.createdAt,
    //this.imageUrl,
    this.sinopse,
    //this.linkReference,
    required this.codeUser,
  });

  Book.empty()
      : this(
          code: DaoEntity.idInvalid,
          title: '',
          author: '',
          gender: '',
          createdAt: DaoEntity.dateInvalid,
          //imageUrl: '',
          sinopse: '',
          //linkReference: '',
          codeUser: DaoEntity.idInvalid,
        );

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      code: map['code'] as int? ?? DaoEntity.idInvalid,
      title: map['title'] as String?,
      author: map['author'] as String?,
      gender: map['gender'] as String?,
      createdAt: map['createdat'] as String?,
      //imageUrl: map['imageurl'] as String?,
      sinopse: map['sinopse'] as String?,
      //linkReference: map['linkreference'] as String?,
      codeUser: map['codeuser'] as int?,
    );
  }

  @override
  void fromMap(Map<String, Object?> map) {
    code = map['code'] as int;
    title = map['title'] as String?;
    author = map['author'] as String?;
    gender = map['gender'] as String?;
    createdAt = map['createdat'] as String?;
    //imageUrl = map['imageurl'] as String?;
    sinopse = map['sinopse'] as String?;
    //linkReference = map['linkreference'] as String?;
    codeUser = map['codeuser'] as int;
  }

  @override
  int get id => code!;

  @override
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'title': title,
      'author': author,
      'gender': gender,
      'createdAt': createdAt,
      //'imageUrl': imageUrl,
      'sinopse': sinopse,
      //'linkReference': linkReference,
      'codeUser': codeUser,
    };
  }

  Map<String, dynamic> toMapWithoutNulls() {
    final map = toMap();
    return map..removeWhere((key, value) => value == null);
  }

  String toJson() => json.encode(toMap());
  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));
}
