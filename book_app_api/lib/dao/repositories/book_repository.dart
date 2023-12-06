import 'package:book_app_api/dao/dao.dart';
import 'package:book_app_api/dao/database.dart';
import 'package:book_app_api/exceptions/book_notfound_exception.dart';
import 'package:book_app_api/model/book.dart';
import 'package:postgres/legacy.dart';
import 'package:postgres/postgres.dart';

class BookRepository implements Dao<Book> {
  @override
  Future<bool> save(Book book) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();

      await conn.execute(
        Sql.named('''
                INSERT INTO 
                books (title, author, gender, createdAt, sinopse, codeUser) 
                VALUES 
                (@title, @author, @gender, @createdAt, @sinopse, @codeUser)
                '''),
        parameters: {
          'title': book.title,
          'author': book.author,
          'gender': book.gender,
          'createdAt': DateTime.now().toString(),
          //'imageUrl': book.imageUrl,
          'sinopse': book.sinopse,
          //'linkReference': book.linkReference,
          'codeUser': book.codeUser,
        },
      );
      return true;
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at Save Book');
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<bool> delete(int id) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();

      await conn.execute(
        Sql.named('DELETE FROM books WHERE code=@code'),
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
  Future<bool> update(Book entity) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();

      await conn.execute(
        Sql.named('''
          UPDATE books
          SET
            title = @title,
            author = @author,
            gender = @gender,
            createdAt = @createdAt,
            sinopse = @sinopse,
            codeUser = @codeUser
          WHERE code = @code
      '''),
        parameters: {
          'code': entity.code,
          'title': entity.title,
          'author': entity.author,
          'gender': entity.gender,
          'createdAt': entity.createdAt,
          //'imageUrl': entity.imageUrl,
          'sinopse': entity.sinopse,
          //'linkReference': entity.linkReference,
          'codeUser': entity.codeUser,
        },
      );

      return true;
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at Update Book');
    } finally {
      await conn?.close();
    }
  }

  Future<List<Book>> findAllBooksByUserId(int id) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();
      final result = await conn.execute(
        Sql.named('''
          SELECT books.*
          FROM books
          JOIN users ON books.codeUser = users.code
          WHERE users.code = @code;
        '''),
        parameters: {
          'code': id,
        },
      );

      if (result.isEmpty) {
        throw BookNotFoundException();
      }

      return result.map((row) => Book.fromMap(row.toColumnMap())).toList();
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at GetAll Book By UserId');
    } finally {
      await conn?.close();
    }
  }
}
