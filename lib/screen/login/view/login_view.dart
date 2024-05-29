import 'package:flutter/material.dart';
import 'package:keylol_flutter/screen/login/widgets/login_with_password_form.dart';
import 'package:keylol_flutter/screen/login/widgets/login_with_sms_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  int _loginType = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/metro.png',
              width: 200,
            ),
            const SizedBox(height: 16),
            if (_loginType == 0) const LoginWithPasswordForm(),
            if (_loginType == 1) const LoginWithSmsForm(),
            const SizedBox(height: 16),
            TextButton(
                onPressed: () {
                  setState(() {
                    if (_loginType == 0) {
                      _loginType = 1;
                    } else {
                      _loginType = 0;
                    }
                  });
                },
                child: _loginType == 0
                    ? Text(AppLocalizations.of(context)!.loginPageLoginWithSms)
                    : Text(AppLocalizations.of(context)!
                        .loginPageLoginWithPassword)),
          ],
        ),
      ),
    );
  }
}
