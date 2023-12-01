part of 'login_with_sms_bloc.dart';

abstract class LoginWithSmsEvent extends Equatable {
  const LoginWithSmsEvent();

  @override
  List<Object> get props => [];
}

class LoginWithSmsSecCodeRequested extends LoginWithSmsEvent {
  final String phone;

  const LoginWithSmsSecCodeRequested(this.phone);
}

class LoginWithSmsSmsCodeSent extends LoginWithSmsEvent {
  final LoginWithSmsModel form;

  const LoginWithSmsSmsCodeSent(this.form);
}

class LoginWithSmsRequested extends LoginWithSmsEvent {
  final LoginWithSmsModel form;

  const LoginWithSmsRequested(this.form);
}
