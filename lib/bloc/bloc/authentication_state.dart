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

class AuthenticaionAuthenticated extends AuthenticationState {
  const AuthenticaionAuthenticated(Variables profile)
      : super(AuthenticationStatus.authenticated, profile);
}
