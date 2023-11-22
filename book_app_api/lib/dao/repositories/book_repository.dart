import 'package:book_app_api/dao/dao.dart';
import 'package:book_app_api/dao/database.dart';
import 'package:book_app_api/exceptions/book_already_registered.dart';
import 'package:book_app_api/exceptions/book_botfound_exception.dart';
import 'package:book_app_api/exceptions/user_notfound_exception.dart';
import 'package:book_app_api/model/book.dart';
import 'package:postgres/legacy.dart';
import 'package:postgres/postgres.dart';

class BookRepository implements Dao<Book> {
  @override
  Future<bool> save(Book book) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();

      final isBookRegister = await conn.execute(
        Sql.named('SELECT * FROM books WHERE title=@title'),
        parameters: {
          'title': book.title,
        },
      );

      final isUserRegister = await conn.execute(
        Sql.named('SELECT * FROM users WHERE code=@code'),
        parameters: {'code': book.codeUser},
      );

      if (isUserRegister.isNotEmpty) {
        if (isBookRegister.isEmpty) {
          await conn.execute(
            Sql.named('''
                INSERT INTO 
                books (title, author, gender, createdAt, imageUrl, sinopse, linkReference, codeUser) 
                VALUES 
                (@title, @author, @gender, @createdAt, @imageUrl, @sinopse, @linkReference, @codeUser)
                '''),
            parameters: {
              'title': book.title,
              'author': book.author,
              'gender': book.gender,
              'createdAt': DateTime.now().toString(),
              'imageUrl': book.imageUrl,
              'sinopse': book.sinopse,
              'linkReference': book.linkReference,
              'codeUser': book.codeUser,
            },
          );
          return true;
        } else {
          throw BookAlreadyRegistered();
        }
      } else {
        throw UserNotFoundException();
      }
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at Save Book');
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<bool> delete(Book entity) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();
      await conn.execute(
        Sql.named('DELETE FROM books WHERE code=@code'),
        parameters: {
          'code': entity.code,
        },
      );
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at Delete Book');
    } finally {
      await conn?.close();
    }

    throw Exception('Unexpected error');
  }

  @override
  Future<List<Book>> findAll() async {
    Connection? conn;
    try {
      conn = await Database().openConnection();

      final result = await conn.execute(
        Sql.named('SELECT * FROM books'),
      );

      if (result.isEmpty) {
        throw BookNotFoundException();
      }

      return result.map((row) => Book.fromMap(row.toColumnMap())).toList();
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at FindAll Book');
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<Book?> findById(int id) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();
      final result = await conn.execute(
          Sql.named('SELECT * FROM books WHERE code=@code'),
          parameters: {
            'code': id,
          });
      if (result.isNotEmpty) {
        return Book.fromMap(result.first.toColumnMap());
      } else {
        throw BookNotFoundException();
      }
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at FindById Book');
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<bool> update(Book entity) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
