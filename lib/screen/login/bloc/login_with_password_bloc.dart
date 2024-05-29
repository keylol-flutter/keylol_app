import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger_manager.dart';
import 'package:keylol_flutter/screen/login/model/login_with_password_model.dart';

part 'login_with_password_event.dart';
part 'login_with_password_state.dart';

class LoginWithPasswordBloc
    extends Bloc<LoginWithPasswordEvent, LoginWithPasswordState> {
  final Keylol _client;

  LoginWithPasswordBloc(this._client)
      : super(const LoginWithPasswordInitial()) {
    on<LoginWithPasswordRequested>(_onLoginWithPasswordRequested);
    on<LoginWithPasswordSecCodeRequested>(_onLoginWithPasswordSecCodeRequested);
  }

  Future<void> _onLoginWithPasswordRequested(
    LoginWithPasswordRequested event,
    Emitter<LoginWithPasswordState> emit,
  ) async {
    final form = event.form;

    try {
      final loginParam = state.loginParam;
      if (loginParam != null) {
        final secCode = form.secCode!;
        final checked = await _client.checkSecCode(
            loginParam: loginParam, secCode: secCode);
        if (!checked) {
          emit(state.copyWith(status: LoginWithPasswordStatus.failure));
          return;
        }

        await _client.loginWithSecCode(
            loginParam: loginParam, secCode: secCode);
        emit(state.copyWith(status: LoginWithPasswordStatus.success));
        return;
      }

      final username = form.username;
      final password = form.password;
      final resp = await _client.loginWithPassword(
          username: username, password: password);
      if (resp.message?.messageVal == 'login_succeed') {
        emit(state.copyWith(status: LoginWithPasswordStatus.success));
      } else if (resp.message?.messageVal == 'login_seccheck2') {
        final variablse = resp.variables;
        final loginParam = await _client.getSecCodeLoginParam(
            variablse.auth ?? '', variablse.formHash);
        loginParam.genIdHash();
        final secCodeData = await _client.getSecCode(
          update: loginParam.update,
          idHash: loginParam.idHash,
        );
        emit(state.copyWith(
          status: LoginWithPasswordStatus.initial,
          loginParam: loginParam,
          secCodeData: secCodeData,
        ));
        return;
      } else {
        emit(state.copyWith(
          status: LoginWithPasswordStatus.failure,
          error: resp.message?.messageStr,
        ));
        return;
      }
    } catch (e, stack) {
      if (e is String) {
        emit(state.copyWith(
          status: LoginWithPasswordStatus.failure,
          error: e,
        ));
      }
      LoggerManager.e('登录失败', error: e, stackTrace: stack);
      emit(state.copyWith(
        status: LoginWithPasswordStatus.failure,
        error: '',
      ));
    }
  }

  Future<void> _onLoginWithPasswordSecCodeRequested(
    LoginWithPasswordSecCodeRequested event,
    Emitter<LoginWithPasswordState> emit,
  ) async {
    try {
      final loginParam = state.loginParam;
      if (loginParam == null) {
        return;
      }

      loginParam.genIdHash();
      final secCodeData = await _client.getSecCode(
          update: loginParam.update, idHash: loginParam.idHash);
      emit(state.copyWith(
        status: LoginWithPasswordStatus.initial,
        loginParam: loginParam,
        secCodeData: secCodeData,
      ));
    } catch (e, stack) {
      LoggerManager.e('获取验证码失败', error: e, stackTrace: stack);
      emit(state.copyWith(
        status: LoginWithPasswordStatus.failure,
        error: '',
      ));
    }
  }
}
