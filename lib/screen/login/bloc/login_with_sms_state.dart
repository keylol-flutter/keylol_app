part of 'login_with_sms_bloc.dart';

enum LoginWithSmsStatus { initial, success, failure }

class LoginWithSmsState extends Equatable {
  final LoginWithSmsStatus status;

  final LoginParam? loginParam;

  final String error;

  const LoginWithSmsState(this.status, this.loginParam, this.error);

  LoginWithSmsState copyWith({
    LoginWithSmsStatus? status,
    LoginParam? loginParam,
    String? error,
  }) {
    return LoginWithSmsState(
      status ?? this.status,
      loginParam ?? this.loginParam,
      error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        loginParam,
        error,
      ];
}

class LoginWithSmsInitial extends LoginWithSmsState {
  const LoginWithSmsInitial() : super(LoginWithSmsStatus.initial, null, '');
}
