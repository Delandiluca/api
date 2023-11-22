import 'dart:convert';

import 'package:book_app_api/dao/dao_entity.dart';

class Note implements DaoEntity {
  int? code;
  int? value;
  String? description;
  String? createdAt;
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

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      code: map['code'] as int? ?? DaoEntity.idInvalid,
      value: map['value'] as int?,
      description: map['description'] as String?,
      createdAt: map['createdat'] as String?,
      codeUser: map['codeuser'] as int?,
      codeBook: map['codebook'] as int?,
    );
  }

  @override
  int get id => code!;

  @override
  void fromMap(Map<String, Object?> map) {
    code = map['code'] as int?;
    value = map['value'] as int?;
    description = map['description'] as String?;
    createdAt = map['createdat'] as String?;
    codeUser = map['codeuser'] as int?;
    codeBook = map['codebook'] as int?;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'value': value,
      'description': description,
      'createdAt': createdAt,
      'codeuser': codeUser,
      'codebook': codeBook,
    };
  }

  Map<String, dynamic> toMapWithoutNulls() {
    final map = toMap();
    return map..removeWhere((key, value) => value == null);
  }

  String toJson() => json.encode(toMap());
  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));
}
