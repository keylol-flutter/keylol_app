import 'package:flutter/material.dart';
import 'package:keylol_flutter/screen/login/widgets/login_with_password_form.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginWithPasswordForm(),
    );
  }
}
