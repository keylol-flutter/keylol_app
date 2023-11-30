import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:keylol_api/keylol_api.dart';

part 'login_with_sms_event.dart';
part 'login_with_sms_state.dart';

class LoginWithSmsBloc extends Bloc<LoginWithSmsEvent, LoginWithSmsState> {
  final Keylol _client;

  LoginWithSmsBloc(this._client) : super(const LoginWithSmsInitial()) {
    on<LoginWithSmsSecCodeRequested>(_onLoginWithSmsSecCodeRequested);
  }

  Future<void> _onLoginWithSmsSecCodeRequested(
    LoginWithSmsSecCodeRequested event,
    Emitter<LoginWithSmsState> emitter,
  ) async {
    late LoginParam loginParam;
    if (state.loginParam == null) {
      loginParam = await _client.getSmsLoginParam(event.phone);
    } else {
      loginParam = state.loginParam!;
    }

    loginParam.genIdHash();
    final secCodeData = await _client.getSecCode(
        update: loginParam.update, idHash: loginParam.idHash);
  }
}
