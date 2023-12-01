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
  final _phoneFormKey = GlobalKey<FormFieldState>();
  final _secCodeFormKey = GlobalKey<FormFieldState>();
  final _smsCodeFormKey = GlobalKey<FormFieldState>();

  final _form = LoginWithSmsModel();

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
            child: Column(
              children: [
                TextFormField(
                  key: _phoneFormKey,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: Text(
                        AppLocalizations.of(context)!.loginPageInputLabelPhone),
                  ),
                  autofillHints: const [AutofillHints.telephoneNumber],
                  validator: (phone) {
                    if (phone == null || phone.isEmpty) {
                      return AppLocalizations.of(context)!
                          .loginPageInputPhoneEmpty;
                    }
                    return null;
                  },
                  onSaved: (phone) => _form.phone = phone!,
                ),
                const SizedBox(height: 16),
                if (state.secCodeData != null)
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: TextFormField(
                          key: _secCodeFormKey,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            label: Text(AppLocalizations.of(context)!
                                .loginPageInputLabelSecCode),
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
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          child: Image.memory(
                            state.secCodeData!,
                            fit: BoxFit.fill,
                          ),
                          onTap: () {
                            context
                                .read<LoginWithSmsBloc>()
                                .add(LoginWithSmsSecCodeRequested(_form.phone));
                          },
                        ),
                      ),
                    ],
                  ),
                if (state.secCodeData != null) const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: _smsCodeFormKey,
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
                    SmsCountDownButton(
                      form: _form,
                      onPressed: () {
                        final phoneFormState = _phoneFormKey.currentState;
                        if (phoneFormState == null) {
                          return false;
                        }

                        if (phoneFormState.validate()) {
                          phoneFormState.save();

                          if (state.loginParam == null) {
                            /// 第一次点击发送验证码时，获取图形验证码
                            context
                                .read<LoginWithSmsBloc>()
                                .add(LoginWithSmsSecCodeRequested(_form.phone));
                          } else {
                            /// 发送验证码需要填写图形验证码
                            final secCodeFormState =
                                _secCodeFormKey.currentState;
                            if (secCodeFormState == null) {
                              return false;
                            }

                            if (secCodeFormState.validate()) {
                              secCodeFormState.save();

                              context
                                  .read<LoginWithSmsBloc>()
                                  .add(LoginWithSmsSmsCodeSent(_form));
                              return true;
                            }
                            return false;
                          }
                        }
                        return false;
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: ElevatedButton(
                    child: Text(
                        AppLocalizations.of(context)!.loginPageLoginButton),
                    onPressed: () {
                      if (_smsCodeFormKey.currentState?.validate() == true) {
                        _smsCodeFormKey.currentState?.save();
                        context
                            .read<LoginWithSmsBloc>()
                            .add(LoginWithSmsRequested(_form));
                      }
                    },
                  ),
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
  final LoginWithSmsModel form;
  final bool Function() onPressed;

  const SmsCountDownButton({
    Key? key,
    required this.form,
    required this.onPressed,
  }) : super(key: key);

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
                  final result = widget.onPressed();

                  if (result) {
                    var second = 60;
                    _timer?.cancel();
                    _timer = Timer.periodic(
                      const Duration(seconds: 1),
                      (timer) {
                        second--;
                        _controller.sink.add(second);
                        if (second == 0) {
                          timer.cancel();
                        }
                      },
                    );
                  }
                },
          child: leftSecond == 0
              ? const Text('获取短信验证码')
              : Text('重新获取(${leftSecond}s)'),
        );
      },
    );
  }
}
