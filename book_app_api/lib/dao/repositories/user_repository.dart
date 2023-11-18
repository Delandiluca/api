import 'package:book_app_api/dao/dao.dart';
import 'package:book_app_api/dao/database.dart';
import 'package:book_app_api/dao/helpers/cripty_helper.dart';
import 'package:book_app_api/exceptions/username_already_registered.dart';
import 'package:book_app_api/exceptions/user_notfound_exception.dart';
import 'package:book_app_api/model/User.dart';
import 'package:postgres/legacy.dart';
import 'package:postgres/postgres.dart';

class UserRepository implements Dao<User> {
  Future<bool> login(String username, String password) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();
      final result = await conn.execute(
        Sql.named(
            'SELECT * FROM users WHERE username=@username AND password=@password'),
        parameters: {
          'username': username,
          'password': CriptyHelper.generatedSha256Hash(password),
        },
      );

      if (result.isNotEmpty) {
        final userData = result.first;
        print('DEBUG USER FIRST: $userData');
      } else {
        throw UserNotFoundException();
      }

      return true;
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Erro ao realizar Login');
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<bool> save(User user) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();

      final isUserRegister = await conn.execute(
        Sql.named('SELECT * FROM users WHERE username=@username'),
        parameters: {
          'username': user.username,
        },
      );

      if (isUserRegister.isEmpty) {
        await conn.execute(
          Sql.named(
              'INSERT INTO users (name, username, password, createdAt) VALUES (@name, @username, @password, @date)'),
          parameters: {
            'name': user.name,
            'username': user.username,
            'password': CriptyHelper.generatedSha256Hash(user.password),
            'date': DateTime.now().toString(),
          },
        );
        return true;
      } else {
        throw UsernameAlreadyRegistered();
      }
    } on PostgreSQLException catch (e, s) {
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
