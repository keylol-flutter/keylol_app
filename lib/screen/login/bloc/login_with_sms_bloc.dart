import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:keylol_api/keylol_api.dart';

part 'login_with_sms_event.dart';
part 'login_with_sms_state.dart';

class LoginWithSmsBloc extends Bloc<LoginWithSmsEvent, LoginWithSmsState> {
  final Keylol _client;

  LoginWithSmsBloc(this._client) : super(LoginWithSmsInitial()) {
    on<LoginWithSmsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
