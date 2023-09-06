part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final Variables profile;

  const AuthenticationState(this.status, this.profile);

  @override
  List<Object> get props => [status, profile];
}

class AuthenticationUnauthenticated extends AuthenticationState {
  AuthenticationUnauthenticated()
      : super(AuthenticationStatus.unauthenticated,
            DefaultVariables.fromJson(const {}));
}

class AuthenticationAuthenticated extends AuthenticationState {
  const AuthenticationAuthenticated(Variables profile)
      : super(AuthenticationStatus.authenticated, profile);
}
