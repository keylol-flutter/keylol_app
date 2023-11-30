import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/bloc/bloc/authentication_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keylol_flutter/screen/login/bloc/login_with_sms_bloc.dart';
import 'package:keylol_flutter/screen/login/model/login_with_sms_model.dart';

class LoginWithSmsForm extends StatefulWidget {
  const LoginWithSmsForm({super.key});

  @override
  State<StatefulWidget> createState() => _LoginWithSmsFormState();
}

class _LoginWithSmsFormState extends State<LoginWithSmsForm> {
  final _formKey = GlobalKey<FormState>();
  final _form = LoginWithSmsModel();

  var _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginWithSmsBloc, LoginWithSmsState>(
      listener: (context, state) {
        if (state.status == LoginWithSmsStatus.success) {
          context.read<AuthenticationBloc>().add(AuthenticationStatusFetched());
          Navigator.of(context).pop();
        } else if (state.status == LoginWithSmsStatus.failure) {
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
        return AutofillGroup(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: Text(
                        AppLocalizations.of(context)!.loginPageInputLabelPhone),
                  ),
                  autofillHints: const [AutofillHints.telephoneNumber],
                  validator: (phone) {
                    if (phone == null || phone.isEmpty) {
                      return AppLocalizations.of(context)!
                          .loginPageInputUsernameEmpty;
                    }
                    return null;
                  },
                  onSaved: (phone) => _form.phone = phone!,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: Text(AppLocalizations.of(context)!
                              .loginPageInputLabelSmsCode),
                        ),
                        validator: (smsCode) {
                          if (smsCode == null || smsCode.isEmpty) {
                            return AppLocalizations.of(context)!
                                .loginPageInputSecCodeEmpty;
                          }
                          return null;
                        },
                        onSaved: (smsCode) => _form.smsCode = smsCode!,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Flexible(flex: 1, child: SmsCountDownButton()),
                  ],
                ),
                ElevatedButton(
                  child:
                      Text(AppLocalizations.of(context)!.loginPageLoginButton),
                  onPressed: () {
                    final formState = _formKey.currentState!;
                    if (formState.validate()) {
                      formState.save();
                      context.read<LoginWithSmsBloc>();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SmsCountDownButton extends StatefulWidget {
  final Function? onPressed;

  const SmsCountDownButton({Key? key, this.onPressed}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmsCountDownButtonState();
}

class _SmsCountDownButtonState extends State<SmsCountDownButton> {
  late StreamController<int> _controller;
  Timer? _timer;

  @override
  void initState() {
    _controller = StreamController();

    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _controller.stream,
      initialData: 0,
      builder: (context, snapshot) {
        final leftSecond = snapshot.data ?? 0;
        return ElevatedButton(
          onPressed: leftSecond != 0
              ? null
              : () {
                  widget.onPressed?.call();
                },
          child: leftSecond == 0
              ? const Text('获取短信验证码')
              : Text('重新获取(${leftSecond}s)'),
        );
      },
    );
  }
}
