import 'package:book_app_api/dao/dao_entity.dart';

abstract interface class Dao<T extends DaoEntity> {
  Future<List<T>> findAll();
  Future<T?> findById(int id);
  Future<bool> save(T entity);
  Future<bool> update(T entity);
  Future<bool> delete(int entity);
}
