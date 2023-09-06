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
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Image.asset(
              'images/metro.png',
              width: 200,
            ),
            const SizedBox(height: 16),
            const LoginWithPasswordForm(),
          ],
        ),
      ),
    );
  }
}
