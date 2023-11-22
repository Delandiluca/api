import 'package:book_app_api/dao/dao.dart';
import 'package:book_app_api/dao/database.dart';
import 'package:book_app_api/exceptions/note_notfound_exception.dart';
import 'package:book_app_api/model/note.dart';
import 'package:postgres/legacy.dart';
import 'package:postgres/postgres.dart';

class NoteRepository implements Dao<Note> {
  @override
  Future<bool> delete(int id) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();

      await conn.execute(
        Sql.named('DELETE FROM notes WHERE code=@code'),
        parameters: {
          'code': id,
        },
      );
      return true;
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at Delete Note');
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<Note>> findAll() async {
    Connection? conn;
    try {
      conn = await Database().openConnection();

      final result = await conn.execute(
        Sql.named('SELECT * FROM notes'),
      );

      if (result.isEmpty) {
        throw NoteNotFoundException();
      }

      return result.map((row) => Note.fromMap(row.toColumnMap())).toList();
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at FindAll Note');
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<Note?> findById(int id) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();
      final result = await conn.execute(
          Sql.named('SELECT * FROM notes WHERE code=@code'),
          parameters: {
            'code': id,
          });
      if (result.isNotEmpty) {
        return Note.fromMap(result.first.toColumnMap());
      } else {
        throw NoteNotFoundException();
      }
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at FindById Note');
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<bool> save(Note entity) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();

      await conn.execute(
        Sql.named(
          'INSERT INTO notes (value, description, createdAt, codeUser, codeBook) VALUES (@value, @description, @createdAt, @codeUser, @codeBook)',
        ),
        parameters: {
          'value': entity.value,
          'description': entity.description,
          'createdAt': DateTime.now().toString(),
          'codeUser': entity.codeUser,
          'codeBook': entity.codeBook,
        },
      );
      return true;
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at Save Note');
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<bool> update(Note entity) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();

      await conn.execute(
        Sql.named('''
          UPDATE notes
          SET
            value = @value,
            description = @description,
            createdAt = @createdAt,
            codeUser = @codeUser,
            codeBook = @codeBook
          WHERE code = @code
      '''),
        parameters: {
          'code': entity.code,
          'value': entity.value,
          'description': entity.description,
          'createdAt': entity.createdAt,
          'codeUser': entity.codeUser,
          'codeBook': entity.codeBook,
        },
      );

      return true;
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at Update Note');
    } finally {
      await conn?.close();
    }
  }

  Future<List<Note>> findAllNotesByUserId(int id) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();
      final result = await conn.execute(
        Sql.named('''
          SELECT notes.*
          FROM notes
          JOIN users ON notes.codeUser = users.code
          WHERE users.code = @code;
        '''),
        parameters: {
          'code': id,
        },
      );

      if (result.isEmpty) {
        throw NoteNotFoundException();
      }

      return result.map((row) => Note.fromMap(row.toColumnMap())).toList();
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at GetAll Notes By UserId');
    } finally {
      await conn?.close();
    }
  }

  Future<List<Note>> findAllNotesByBookId(int id) async {
    Connection? conn;
    try {
      conn = await Database().openConnection();
      final result = await conn.execute(
        Sql.named('''
          SELECT notes.*
          FROM notes
          JOIN books ON notes.codeBook = books.code
          WHERE books.code = @code;
        '''),
        parameters: {
          'code': id,
        },
      );

      if (result.isEmpty) {
        throw NoteNotFoundException();
      }

      return result.map((row) => Note.fromMap(row.toColumnMap())).toList();
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error at GetAll Notes By BookId');
    } finally {
      await conn?.close();
    }
  }
}
