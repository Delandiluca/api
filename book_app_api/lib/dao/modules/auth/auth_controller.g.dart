// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$AuthControllerRouter(AuthController service) {
  final router = Router();
  router.add(
    'POST',
    r'/register',
    service.register,
  );
  router.add(
    'POST',
    r'/login',
    service.login,
  );
  router.add(
    'GET',
    r'/<code>',
    service.findById,
  );
  router.add(
    'GET',
    r'/',
    service.findAll,
  );
  router.add(
    'DELETE',
    r'/<code>',
    service.deleteUser,
  );
  return router;
}
