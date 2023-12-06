import 'package:book_app_api/dao/dao.dart';
import 'package:book_app_api/dao/database.dart';
import 'package:book_app_api/dao/helpers/cripty_helper.dart';
import 'package:book_app_api/exceptions/username_already_registered.dart';
import 'package:book_app_api/exceptions/user_notfound_exception.dart';
import 'package:book_app_api/model/user.dart';
import 'package:postgres/legacy.dart';
import 'package:postgres/postgres.dart';

class UserRepository implements Dao<User> {
  Future<User?> login(String username, String password) async {
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

      return User.fromMap(result.first.toColumnMap());
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at Login');
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
  Future<bool> delete(int id) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();

      await conn.execute(
        Sql.named('DELETE FROM users WHERE code=@code'),
        parameters: {
          'code': id,
        },
      );
      return true;
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at Delete Book');
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<User>> findAll() async {
    Connection? conn;
    try {
      conn = await Database().openConnection();

      final result = await conn.execute(
        Sql.named('SELECT * FROM users'),
      );

      if (result.isEmpty) {
        throw UserNotFoundException();
      }

      return result.map((row) => User.fromMap(row.toColumnMap())).toList();
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at FindAll Users');
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<User?> findById(int id) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();
      final result = await conn.execute(
          Sql.named('SELECT * FROM users WHERE code=@code'),
          parameters: {
            'code': id,
          });
      if (result.isNotEmpty) {
        return User.fromMap(result.first.toColumnMap());
      } else {
        throw UserNotFoundException();
      }
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at FindById User');
    } finally {
      await conn?.close();
    }
  }
}
