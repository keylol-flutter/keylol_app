import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/bloc/bloc/authentication_bloc.dart';
import 'package:keylol_flutter/screen/login/bloc/login_with_password_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keylol_flutter/screen/login/model/login_with_password_model.dart';

class LoginWithPasswordForm extends StatefulWidget {
  const LoginWithPasswordForm({super.key});

  @override
  State<StatefulWidget> createState() => _LoginWithPasswordFormState();
}

class _LoginWithPasswordFormState extends State<LoginWithPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _form = LoginWithPasswordModel();

  var _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginWithPasswordBloc, LoginWithPasswordState>(
      listener: (context, state) {
        if (state.status == LoginWithPasswordStatus.success) {
          context.read<AuthenticationBloc>().add(AuthenticationStatusFetched());
          Navigator.of(context).pop();
        } else if (state.status == LoginWithPasswordStatus.failure) {
          final message = state.error.isNotEmpty
              ? state.error
              : AppLocalizations.of(context)!.loginPageError;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Center(
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(AppLocalizations.of(context)!
                          .loginPageInputLabelUsername),
                    ),
                    autofillHints: const [AutofillHints.username],
                    validator: (username) {
                      if (username == null || username.isEmpty) {
                        return AppLocalizations.of(context)!
                            .loginPageInputUsernameEmpty;
                      }
                      return null;
                    },
                    onSaved: (username) => _form.username = username!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(AppLocalizations.of(context)!
                          .loginPageInputLabelPassword),
                      suffixIcon: IconButton(
                        icon: _passwordVisible
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () async {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    autofillHints: const [AutofillHints.password],
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return AppLocalizations.of(context)!
                            .loginPageInputPasswordEmpty;
                      }
                      return null;
                    },
                    onSaved: (password) => _form.password = password!,
                  ),
                  const SizedBox(height: 16),
                  if (state.secCodeData != null)
                    TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: Text(AppLocalizations.of(context)!
                            .loginPageInputLabelSecCode),
                        suffix: Image.memory(state.secCodeData!),
                      ),
                      validator: (secCode) {
                        if (secCode == null || secCode.isEmpty) {
                          return AppLocalizations.of(context)!
                              .loginPageInputSecCodeEmpty;
                        }
                        return null;
                      },
                      onSaved: (secCode) => _form.secCode = secCode!,
                    ),
                  ElevatedButton(
                    child: Text(
                        AppLocalizations.of(context)!.loginPageLoginButton),
                    onPressed: () {
                      final formState = _formKey.currentState!;
                      if (formState.validate()) {
                        formState.save();
                        context
                            .read<LoginWithPasswordBloc>()
                            .add(LoginWithPasswordRequested(_form));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
