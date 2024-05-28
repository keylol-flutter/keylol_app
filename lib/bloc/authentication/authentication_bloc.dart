import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Keylol _client;
  final AuthenticationRepository _repository;
  late StreamSubscription<AuthenticationStatus> _streamSubscription;

  AuthenticationBloc(this._client, this._repository)
      : super(AuthenticationUnauthenticated()) {
    _streamSubscription = _repository.status
        .listen((status) => add(AuthenticationStatusChanged(status)));
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationStatusFetched>(_onAuthenticationStatusFetched);
  }

  @override
  Future<void> close() async {
    _streamSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        emit(AuthenticationUnauthenticated());
        break;
      case AuthenticationStatus.authenticated:
        emit(AuthenticationAuthenticated(_repository.profile));
        break;
    }
  }

  Future<void> _onAuthenticationStatusFetched(
    AuthenticationStatusFetched event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _client.profile(null);
  }
}
