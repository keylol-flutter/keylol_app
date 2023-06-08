part of 'login_with_password_bloc.dart';

enum LoginWithPasswordStatus { initial, success, failure }

class LoginWithPasswordState {
  final LoginWithPasswordStatus status;
  final String error;

  final LoginParam? loginParam;
  final Uint8List? secCodeData;

  const LoginWithPasswordState(
      this.status, this.error, this.loginParam, this.secCodeData);

  LoginWithPasswordState copyWith({
    LoginWithPasswordStatus? status,
    String? error,
    LoginParam? loginParam,
    Uint8List? secCodeData,
  }) {
    return LoginWithPasswordState(
      status ?? this.status,
      error ?? this.error,
      loginParam ?? this.loginParam,
      secCodeData ?? this.secCodeData,
    );
  }
}

class LoginWithPasswordInitial extends LoginWithPasswordState {
  const LoginWithPasswordInitial()
      : super(LoginWithPasswordStatus.initial, '', null, null);
}
