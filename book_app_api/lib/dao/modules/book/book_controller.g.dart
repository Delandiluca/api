// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$BookControllerRouter(BookController service) {
  final router = Router();
  router.add(
    'POST',
    r'/register',
    service.register,
  );
  router.add(
    'GET',
    r'/<code>',
    service.findById,
  );
  router.add(
    'GET',
    r'/',
    service.findAllBooks,
  );
  router.add(
    'DELETE',
    r'/<code>',
    service.deleteBook,
  );
  router.add(
    'PUT',
    r'/<code>',
    service.updateBook,
  );
  router.add(
    'GET',
    r'/user/<code>',
    service.findAllBooksByUser,
  );
  return router;
}
