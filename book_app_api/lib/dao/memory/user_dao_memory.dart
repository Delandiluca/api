import 'package:book_app_api/dao/dao.dart';
import 'package:book_app_api/model/User.dart';

class BookDaoMemory implements Dao<User> {
  List<User> listUsers = [
    User(
      code: 1,
      name: 'Delandi Lucas',
      username: 'delandilucas',
      password: 'admin',
    ),
    User(
      code: 2,
      name: 'Agda Silva',
      username: 'agda',
      password: 'admin',
    ),
  ];

  @override
  Future<List<User>> findAll() async {
    return listUsers;
  }

  @override
  Future<User?> findById(int id) async {
    for (int i = 0; i < listUsers.length; i++) {
      if (listUsers[i].code == id) {
        return listUsers[i];
      }
    }
    return null;
  }

  @override
  Future<bool> save(User entity) async {
    listUsers.add(entity);
    return true;
  }

  @override
  Future<bool> update(User entity) async {
    for (int i = 0; i < listUsers.length; i++) {
      if (listUsers[i].code == entity.code) {
        listUsers[i] = entity;
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> delete(User entity) async {
    for (int i = 0; i < listUsers.length; i++) {
      if (listUsers[i].code == entity.code) {
        listUsers.removeAt(i);
        return true;
      }
    }
    return false;
  }
}
