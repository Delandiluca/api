abstract class DaoEntity {
  static int idInvalid = -1;
  int get id;
  void fromMap(Map<String, Object?> map);
  Map<String, Object?> toMap();
}
