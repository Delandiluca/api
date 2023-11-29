import 'dart:async';
import 'dart:convert';

import 'package:book_app_api/dao/repositories/user_repository.dart';
import 'package:book_app_api/exceptions/username_already_registered.dart';
import 'package:book_app_api/exceptions/user_notfound_exception.dart';
import 'package:book_app_api/model/User.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_controller.g.dart';

class AuthController {
  final _userRepository = UserRepository();

  @Route.post('/register')
  Future<Response> register(Request request) async {
    final requestBody = await request.readAsString();
    //print('Debug Register - Request Body: $requestBody');
    final userRq = User.fromJson(requestBody);
    //print('Debug Register - Request Body JSON: $userRq');
    try {
      await _userRepository.save(userRq);

      return Response(200, headers: {'content-type': 'application/json'});
    } on UsernameAlreadyRegistered catch (e, s) {
      print('Debug Register - Exception: $e');
      print('Debug Register - Stack Trace: $s');
      return Response(400,
          body: jsonEncode({'error': 'Username Already exists.'}),
          headers: {
            'content-type': 'application/json',
          });
    } catch (e, s) {
      //print("teste debug:");
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.post('/')
  Future<Response> login(Request request) async {
    final requestBody = await request.readAsString();
    final jsonRQ = jsonDecode(requestBody);

    try {
      print('Debug Login - Request Body: $requestBody');
      print('Debug Login - Request Body JSONDECODE: $jsonRQ');
      final user =
          await _userRepository.login(jsonRQ['username'], jsonRQ['password']);

      return Response(200, body: jsonEncode(user), headers: {
        'content-type': 'application/json',
      });
    } on UserNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response(403, body: 'User not found', headers: {
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
    final int codeUser = int.parse(code);
    try {
      final user = await _userRepository.findById(codeUser);
      return Response(200,
          headers: {
            'content-type': 'application/json',
          },
          body: jsonEncode(user?.toMapWithoutNulls()));
    } on UserNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response.notFound('User not found');
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
