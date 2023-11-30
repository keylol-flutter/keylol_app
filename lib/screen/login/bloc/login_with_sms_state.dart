part of 'login_with_sms_bloc.dart';

enum LoginWithSmsStatus { initial, success, failure }

class LoginWithSmsState extends Equatable {
  final LoginWithSmsStatus status;

  final LoginParam? loginParam;
  final Uint8List? secCodeData;

  final String error;

  const LoginWithSmsState(
    this.status,
    this.loginParam,
    this.secCodeData,
    this.error,
  );

  LoginWithSmsState copyWith({
    LoginWithSmsStatus? status,
    LoginParam? loginParam,
    Uint8List? secCodeData,
    String? error,
  }) {
    return LoginWithSmsState(
      status ?? this.status,
      loginParam ?? this.loginParam,
      secCodeData ?? this.secCodeData,
      error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        loginParam,
        secCodeData,
        error,
      ];
}

class LoginWithSmsInitial extends LoginWithSmsState {
  const LoginWithSmsInitial() : super(LoginWithSmsStatus.initial, null, null, '');
}
