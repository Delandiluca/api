import 'dart:convert';

import 'package:book_app_api/dao/repositories/book_repository.dart';
import 'package:book_app_api/exceptions/book_already_registered.dart';
import 'package:book_app_api/exceptions/book_botfound_exception.dart';
import 'package:book_app_api/exceptions/user_notfound_exception.dart';
import 'package:book_app_api/model/book.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'book_controller.g.dart';

class BookController {
  final _bookRepository = BookRepository();

  @Route.post('/register')
  Future<Response> register(Request request) async {
    final requestBody = await request.readAsString();
    final bookRq = Book.fromJson(requestBody);
    try {
      await _bookRepository.save(bookRq);

      return Response(200, headers: {'content-type': 'application/json'});
    } on BookAlreadyRegistered catch (e, s) {
      print('Debug Register - Exception: $e');
      print('Debug Register - Stack Trace: $s');
      return Response(400,
          body: jsonEncode({'error': 'Book Already exists.'}),
          headers: {
            'content-type': 'application/json',
          });
    } on UserNotFoundException catch (e, s) {
      print('Debug Register - Exception: $e');
      print('Debug Register - Stack Trace: $s');
      return Response(400,
          body: jsonEncode({'error': 'User Not Found!!'}),
          headers: {
            'content-type': 'application/json',
          });
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

  Router get router => _$BookControllerRouter(this);
}
