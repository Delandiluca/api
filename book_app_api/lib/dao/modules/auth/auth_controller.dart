import 'dart:async';
import 'dart:convert';

import 'package:book_app_api/dao/repositories/user_repository.dart';
import 'package:book_app_api/exceptions/email_already_registered.dart';
import 'package:book_app_api/exceptions/user_notfound_exception.dart';
import 'package:book_app_api/model/User.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_controller.g.dart';

class AuthController {
  final _userRepository = UserRepository();

  @Route.post('/register')
  Future<Response> register(Request request) async {
    try {
      final userRegister = User.fromJson(await request.readAsString());

      await _userRepository.save(userRegister);

      return Response(200, headers: {'content-type': 'application/json'});
    } on EmailAlreadyRegistered catch (e, s) {
      print(e);
      print(s);
      return Response(400,
          body: jsonEncode({'error': 'E-mail Already exists.'}),
          headers: {
            'content-type': 'application/json',
          });
    } catch (e, s) {
      print("teste debug:");
      print(e);
      print(s);
      return Response(500, body: 'InternalServerError');
    }
  }

  @Route.post('/')
  Future<Response> login(Request request) async {
    final user = User.fromJson(await request.readAsString());
    try {
      return Response(200, body: jsonEncode(user), headers: {
        'content-type': 'application/json',
      });
    } on UserNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response(403, headers: {
        'content-type': 'application/json',
      });
    } catch (e, s) {
      print(e);
      print(s);
      return Response(500, body: 'InternalServerError');
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
