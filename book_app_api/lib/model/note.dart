import 'package:book_app_api/dao/dao_entity.dart';

class Note implements DaoEntity {
  int? code;
  int value;
  String? description;
  String createdAt;
  int? codeUser;
  int? codeBook;

  Note({
    required this.code,
    required this.value,
    required this.description,
    required this.createdAt,
    required this.codeUser,
    required this.codeBook,
  });

  Note.empty()
      : this(
          code: DaoEntity.idInvalid,
          value: 0,
          description: '',
          createdAt: DaoEntity.dateInvalid,
          codeUser: DaoEntity.idInvalid,
          codeBook: DaoEntity.idInvalid,
        );

  Note.fromMap(Map<String, Object?> map)
      : this(
          code: map['code'] as int,
          value: map['value'] as int,
          description: map['description'] as String?,
          createdAt: map['createdAt'] as String,
          codeUser: map['user'] as int?,
          codeBook: map['book'] as int?,
        );

  @override
  int get id => code!;

  @override
  void fromMap(Map<String, Object?> map) {
    code = map['code'] as int;
    value = map['value'] as int;
    description = map['description'] as String?;
    createdAt = map['createdAt'] as String;
    codeUser = map['user'] as int?;
    codeBook = map['book'] as int?;
  }

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'code': code,
      'value': value,
      'description': description,
      'createdAt': createdAt,
      'user': codeUser,
      'book': codeBook,
    };
    return map;
  }
}
