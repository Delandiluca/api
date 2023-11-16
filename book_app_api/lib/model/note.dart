import 'package:book_app_api/dao/dao_entity.dart';

class Note implements DaoEntity {
  int code;
  int value;
  String? description;
  String codeUser;
  String codeBook;

  Note({
    required this.code,
    required this.value,
    required this.description,
    required this.codeUser,
    required this.codeBook,
  });

  Note.empty()
      : this(
          code: DaoEntity.idInvalid,
          value: 0,
          description: '',
          codeUser: '',
          codeBook: '',
        );

  Note.fromMap(Map<String, Object?> map)
      : this(
          code: map['code'] as int,
          value: map['value'] as int,
          description: map['description'] as String?,
          codeUser: map['user'] as String,
          codeBook: map['book'] as String,
        );

  @override
  int get id => code;

  @override
  void fromMap(Map<String, Object?> map) {
    code = map['code'] as int;
    value = map['value'] as int;
    description = map['description'] as String?;
    codeUser = map['user'] as String;
    codeBook = map['book'] as String;
  }

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'code': code,
      'value': value,
      'description': description,
      'user': codeUser,
      'book': codeBook,
    };
    return map;
  }
}
