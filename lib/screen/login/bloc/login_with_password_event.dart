part of 'login_with_password_bloc.dart';

abstract class LoginWithPasswordEvent extends Equatable {
  const LoginWithPasswordEvent();

  @override
  List<Object> get props => [];
}

class LoginWithPasswordRequested extends LoginWithPasswordEvent {
  final LoginWithPasswordModel form;

  const LoginWithPasswordRequested(this.form);
}
