import 'dart:async';

import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger.dart';

enum AuthenticationStatus { authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  Variables _profile = DefaultVariables.fromJson(const {});

  AuthenticationRepository._();

  static AuthenticationRepository? _instance;

  static AuthenticationRepository getInstance() =>
      _instance ?? AuthenticationRepository._();

  void dispose() {
    _controller.close();
  }

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Variables get profile => _profile;

  set profile(Variables variables) {
    if (_profile == variables) {
      return;
    }
    _profile = variables;
    if (variables.memberUid.isEmpty || variables.memberUid == '0') {
      _controller.add(AuthenticationStatus.unauthenticated);
    } else {
      _controller.add(AuthenticationStatus.authenticated);
    }
  }
}

class AuthenticationInterceptor extends KeylolInterceptor {
  final AuthenticationRepository _repository;

  AuthenticationInterceptor(this._repository);

  @override
  void doIntercept(response) {
    try {
      final resp = ApiResponse.empty(response.data);
      _repository.profile = resp.variables;
    } catch (e, stack) {
      logger.e('拦截器获取用户信息失败', e, stack);
      rethrow;
    }
  }
}
