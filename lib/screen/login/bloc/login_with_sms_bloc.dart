import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger.dart';
import 'package:keylol_flutter/screen/login/model/login_with_sms_model.dart';

part 'login_with_sms_event.dart';

part 'login_with_sms_state.dart';

class LoginWithSmsBloc extends Bloc<LoginWithSmsEvent, LoginWithSmsState> {
  final Keylol _client;

  LoginWithSmsBloc(this._client) : super(const LoginWithSmsInitial()) {
    on<LoginWithSmsSecCodeRequested>(_onLoginWithSmsSecCodeRequested);
    on<LoginWithSmsSmsCodeSent>(_onLoginWithSmsSmsCodeSent);
    on<LoginWithSmsRequested>(_onLoginWithSmsRequested);
  }

  Future<void> _onLoginWithSmsSecCodeRequested(
    LoginWithSmsSecCodeRequested event,
    Emitter<LoginWithSmsState> emit,
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

    emit(state.copyWith(
      loginParam: loginParam,
      secCodeData: secCodeData,
    ));
  }

  Future<void> _onLoginWithSmsSmsCodeSent(
    LoginWithSmsSmsCodeSent event,
    Emitter<LoginWithSmsState> emit,
  ) async {
    final loginParam = state.loginParam!;
    final form = event.form;

    final checked = await _client.checkSecCode(
        loginParam: loginParam, secCode: form.secCode!);
    if (!checked) {
      emit(state.copyWith(status: LoginWithSmsStatus.failure));
      return;
    }

    await _client.sendSms(
      loginParam: loginParam,
      cellphone: form.phone,
      secCode: form.secCode!,
    );

    emit(LoginWithSmsState(
      LoginWithSmsStatus.initial,
      loginParam,
      state.secCodeData,
      '',
    ));
  }

  Future<void> _onLoginWithSmsRequested(
    LoginWithSmsRequested event,
    Emitter<LoginWithSmsState> emit,
  ) async {
    try {
      final form = event.form;
      await _client.loginWithSms(
        loginParam: state.loginParam!,
        cellphone: form.phone,
        sms: form.smsCode,
      );
    } catch (e, stack) {
      if (e is String) {
        emit(state.copyWith(
          status: LoginWithSmsStatus.failure,
          error: e,
        ));
      }
      logger.e('登录失败', e, stack);
      emit(state.copyWith(
        status: LoginWithSmsStatus.failure,
        error: '',
      ));
    }
  }
}
