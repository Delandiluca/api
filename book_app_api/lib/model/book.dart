import 'package:book_app_api/dao/dao_entity.dart';

class Book implements DaoEntity {
  int code;
  String? title;
  String? author;
  String? gender;
  String? datePublished;
  String? imageUrl;
  String? sinopse;
  String? linkReference;
  String codeUser;

  Book({
    required this.code,
    this.title,
    this.author,
    this.gender,
    this.datePublished,
    this.imageUrl,
    this.sinopse,
    this.linkReference,
    required this.codeUser,
  });

  Book.empty()
      : this(
          code: DaoEntity.idInvalid,
          title: '',
          author: '',
          gender: '',
          datePublished: '',
          imageUrl: '',
          sinopse: '',
          linkReference: '',
          codeUser: '',
        );

  Book.fromMap(Map<String, Object?> map)
      : this(
          code: map['code'] as int,
          title: map['title'] as String?,
          author: map['author'] as String?,
          gender: map['gender'] as String?,
          datePublished: map['datePublished'] as String?,
          imageUrl: map['imageUrl'] as String?,
          sinopse: map['sinopse'] as String?,
          linkReference: map['linkReference'] as String?,
          codeUser: map['codeUser'] as String,
        );

  @override
  void fromMap(Map<String, Object?> map) {
    code = map['code'] as int;
    title = map['title'] as String?;
    author = map['author'] as String?;
    gender = map['gender'] as String?;
    datePublished = map['datePublished'] as String?;
    imageUrl = map['imageUrl'] as String?;
    sinopse = map['sinopse'] as String?;
    linkReference = map['linkReference'] as String?;
    codeUser = map['codeUser'] as String;
  }

  @override
  int get id => code;

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'code': code,
      'title': title,
      'author': author,
      'gender': gender,
      'datePublished': datePublished,
      'imageUrl': imageUrl,
      'sinopse': sinopse,
      'linkReference': linkReference,
      'codeUser': codeUser,
    };
    return map;
  }
}
