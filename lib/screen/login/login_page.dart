import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/login/bloc/login_with_password_bloc.dart';
import 'package:keylol_flutter/screen/login/bloc/login_with_sms_bloc.dart';
import 'package:keylol_flutter/screen/login/view/login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => LoginWithPasswordBloc(context.read<Keylol>())),
        BlocProvider(
            create: (context) => LoginWithSmsBloc(context.read<Keylol>())),
      ],
      child: const LoginView(),
    );
  }
}
