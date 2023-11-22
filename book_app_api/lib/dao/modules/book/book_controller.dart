import 'dart:convert';

import 'package:book_app_api/dao/repositories/book_repository.dart';
import 'package:book_app_api/dao/repositories/user_repository.dart';
import 'package:book_app_api/exceptions/book_already_registered.dart';
import 'package:book_app_api/exceptions/book_notfound_exception.dart';
import 'package:book_app_api/exceptions/user_notfound_exception.dart';
import 'package:book_app_api/model/book.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'book_controller.g.dart';

class BookController {
  final _bookRepository = BookRepository();
  final _userRepository = UserRepository();

  @Route.post('/register')
  Future<Response> register(Request request) async {
    final requestBody = await request.readAsString();
    final bookRq = Book.fromJson(requestBody);
    try {
      final existingUser = await _userRepository.findById(bookRq.codeUser!);
      if (existingUser == null) {
        throw UserNotFoundException();
      }

      await _bookRepository.save(bookRq);
      return Response.ok('Book Saved');
    } on BookAlreadyRegistered catch (e, s) {
      print(e);
      print(s);
      return Response.badRequest(body: 'Book Already Registered');
    } on UserNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response.notFound('User Not Found');
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.get('/<code>')
  Future<Response> findById(Request request, String code) async {
    final int codeBook = int.parse(code);
    try {
      final book = await _bookRepository.findById(codeBook);
      return Response(200,
          headers: {
            'content-type': 'application/json',
          },
          body: jsonEncode(book?.toMapWithoutNulls()));
    } on BookNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response(403, body: 'Book not found', headers: {
        'content-type': 'application/json',
      });
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.get('/')
  Future<Response> findAllBooks(Request request) async {
    try {
      final books = await _bookRepository.findAll();
      final booksWithoutNulls =
          books.map((book) => book.toMapWithoutNulls()).toList();
      return Response(200, body: jsonEncode(booksWithoutNulls), headers: {
        'content-type': 'application/json',
      });
    } on BookNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response(403, body: 'Book not found', headers: {
        'content-type': 'application/json',
      });
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.delete('/<code>')
  Future<Response> deleteBook(Request request, String code) async {
    final int codeBook = int.parse(code);
    try {
      final existingBook = await _bookRepository.findById(codeBook);
      if (existingBook == null) {
        throw BookNotFoundException();
      }
      await _bookRepository.delete(codeBook);
      return Response.ok('Book Deleted!');
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

  @Route.put('/<code>')
  Future<Response> updateBook(Request request, String code) async {
    final int codeBook = int.parse(code);
    final requestBody = await request.readAsString();
    final updatedBook = Book.fromJson(requestBody);
    try {
      final existingBook = await _bookRepository.findById(codeBook);
      if (existingBook == null) {
        return Response.notFound('Book Not Found');
      }

      updatedBook.code = codeBook;
      await _bookRepository.update(updatedBook);
      return Response.ok('Book Updated!');
    } on Exception catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.get('/findAllBooksByUser/<code>')
  Future<Response> findAllBooksByUser(Request request, String code) async {
    final int codeUser = int.parse(code);
    try {
      final existingUser = await _userRepository.findById(codeUser);
      if (existingUser == null) {
        return Response.notFound('User Not Found');
      }

      final books = await _bookRepository.findAllBooksByUserId(codeUser);
      final booksWithoutNulls =
          books.map((book) => book.toMapWithoutNulls()).toList();
      return Response(200, body: jsonEncode(booksWithoutNulls), headers: {
        'content-type': 'application/json',
      });
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

  Router get router => _$BookControllerRouter(this);
}
