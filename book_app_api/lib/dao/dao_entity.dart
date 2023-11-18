abstract class DaoEntity {
  static int? idInvalid = -1;
  static String dateInvalid = '00/00/0000';
  int get id;
  void fromMap(Map<String, Object?> map);
  Map<String, dynamic> toMap();
}
