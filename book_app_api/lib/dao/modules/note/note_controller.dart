import 'dart:convert';

import 'package:book_app_api/dao/repositories/book_repository.dart';
import 'package:book_app_api/dao/repositories/note_repository.dart';
import 'package:book_app_api/dao/repositories/user_repository.dart';
import 'package:book_app_api/exceptions/book_notfound_exception.dart';
import 'package:book_app_api/exceptions/note_notfound_exception.dart';
import 'package:book_app_api/exceptions/user_notfound_exception.dart';
import 'package:book_app_api/model/note.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'note_controller.g.dart';

class NoteController {
  final _noteRepository = NoteRepository();
  final _userRepository = UserRepository();
  final _bookRepository = BookRepository();

  @Route.post('/register')
  Future<Response> saveNote(Request request) async {
    final requestBody = await request.readAsString();
    final noteRq = Note.fromJson(requestBody);
    try {
      final existingUser = await _userRepository.findById(noteRq.codeUser!);
      final existingBook = await _bookRepository.findById(noteRq.codeBook!);
      if (existingUser == null) {
        throw UserNotFoundException();
      } else if (existingBook == null) {
        throw BookNotFoundException();
      }
      await _noteRepository.save(noteRq);
      return Response.ok('Note Saved');
    } on UserNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response.notFound('User Not Found');
    } on BookNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response.notFound('Book Not Found');
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.get('/<code>')
  Future<Response> findById(Request request, String code) async {
    final int codeNote = int.parse(code);
    try {
      final note = await _noteRepository.findById(codeNote);
      return Response(200,
          headers: {
            'content-type': 'application/json',
          },
          body: jsonEncode(note?.toMapWithoutNulls()));
    } on NoteNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response.notFound('Note not found');
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.get('/')
  Future<Response> findAllNotes(Request request) async {
    try {
      final notes = await _noteRepository.findAll();
      final notesWithoutNulls =
          notes.map((note) => note.toMapWithoutNulls()).toList();
      return Response(200, body: jsonEncode(notesWithoutNulls), headers: {
        'content-type': 'application/json',
      });
    } on NoteNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response.notFound('Note not found');
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.delete('/<code>')
  Future<Response> deleteNote(Request request, String code) async {
    final int codeNote = int.parse(code);
    try {
      final existingNote = await _noteRepository.findById(codeNote);
      if (existingNote == null) {
        throw BookNotFoundException();
      }
      await _bookRepository.delete(codeNote);
      return Response.ok('Note Deleted!');
    } on NoteNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response.notFound('Note Not Found');
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.put('/<code>')
  Future<Response> updateNote(Request request, String code) async {
    final int codeNote = int.parse(code);
    final requestBody = await request.readAsString();
    final updatedNote = Note.fromJson(requestBody);
    try {
      final existingNote = await _noteRepository.findById(codeNote);
      if (existingNote == null) {
        return Response.notFound('Note Not Found');
      }

      updatedNote.code = codeNote;
      await _noteRepository.update(updatedNote);
      return Response.ok('Note Updated!');
    } on Exception catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.get('/findAllNotesByUser/<code>')
  Future<Response> findAllNotesByUser(Request request, String code) async {
    final int codeUser = int.parse(code);
    try {
      final existingUser = await _userRepository.findById(codeUser);
      if (existingUser == null) {
        return Response.notFound('User Not Found');
      }

      final notes = await _noteRepository.findAllNotesByUserId(codeUser);
      final notesWithoutNulls =
          notes.map((note) => note.toMapWithoutNulls()).toList();
      return Response(200, body: jsonEncode(notesWithoutNulls), headers: {
        'content-type': 'application/json',
      });
    } on NoteNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response.notFound('Note Not Found');
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.get('/findAllNotesByBook/<code>')
  Future<Response> findAllNotesByBook(Request request, String code) async {
    final int codeBook = int.parse(code);
    try {
      final existingBook = await _userRepository.findById(codeBook);
      if (existingBook == null) {
        return Response.notFound('Book Not Found');
      }

      final notes = await _noteRepository.findAllNotesByBookId(codeBook);
      final notesWithoutNulls =
          notes.map((note) => note.toMapWithoutNulls()).toList();
      return Response(200, body: jsonEncode(notesWithoutNulls), headers: {
        'content-type': 'application/json',
      });
    } on NoteNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response.notFound('Note Not Found');
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  Router get router => _$NoteControllerRouter(this);
}
