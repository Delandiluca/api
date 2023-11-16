import 'package:book_app_api/dao/dao.dart';
import 'package:book_app_api/dao/database.dart';
import 'package:book_app_api/dao/helpers/cripty_helper.dart';
import 'package:book_app_api/exceptions/email_already_registered.dart';
import 'package:book_app_api/exceptions/user_notfound_exception.dart';
import 'package:book_app_api/model/User.dart';
import 'package:mysql1/mysql1.dart';

class UserRepository implements Dao<User> {
  Future<bool> login(String username, String password) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      final result = await conn.query('''
        SELECT * FROM users
        WHERE username = ? 
        AND password = ?
      ''', [
        username,
        CriptyHelper.generatedSha256Hash(password),
      ]);

      if (result.isEmpty) {
        throw UserNotFoundException();
      }

      return true;
    } on Exception catch (e, s) {
      print(e);
      print(s);
      throw Exception('Erro ao realizar Login');
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<bool> save(User user) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();

      final isUserRegister = await conn
          .query('select * from users where username = ?', [user.username]);

      if (isUserRegister.isEmpty) {
        await conn.query('''
          INSERT INTO users
          values(?, ?, ?, ?)
        ''', [
          null,
          user.name,
          user.username,
          CriptyHelper.generatedSha256Hash(user.password),
        ]);
        return true;
      } else {
        throw EmailAlreadyRegistered();
      }
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<bool> update(User user) async {
    //TODO: implement update
    return false;
  }

  @override
  Future<bool> delete(User user) async {
    //TODO: implement delete
    return false;
  }

  @override
  Future<List<User>> findAll() async {
    //TODO: implement findAll
    return [];
  }

  @override
  Future<User?> findById(int id) async {
    //TODO: implement findById
    return null;
  }
}
