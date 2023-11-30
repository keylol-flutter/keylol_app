part of 'login_with_sms_bloc.dart';

abstract class LoginWithSmsEvent extends Equatable {
  const LoginWithSmsEvent();

  @override
  List<Object> get props => [];
}

class LoginWithSmsSecCodeRequested extends LoginWithSmsEvent {
  final String phone;

  const LoginWithSmsSecCodeRequested({required this.phone});
}
