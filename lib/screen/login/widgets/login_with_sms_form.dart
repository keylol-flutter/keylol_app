import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
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
                    SmsCountDownButton(
                      form: _form,
                      onPressed: () {
                        _formKey.currentState?.save();
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  child:
                      Text(AppLocalizations.of(context)!.loginPageLoginButton),
                  onPressed: () {
                    if (_form.secCode == null) {
                    } else {
                      final formState = _formKey.currentState!;
                      if (formState.validate()) {
                        formState.save();
                        context.read<LoginWithSmsBloc>();
                      }
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
  final LoginWithSmsModel form;
  final Function onPressed;

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
                  widget.onPressed();

                  showDialog(
                    context: context,
                    builder: (_) {
                      return SecCodeDialog(
                        phone: widget.form.phone,
                        onSecCode: (secCode) {
                          widget.form.secCode = secCode;
                          context
                              .read<LoginWithSmsBloc>()
                              .add(LoginWithSmsSmsCodeSent(widget.form));

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
                        },
                        onPressed: () {
                          context.read<LoginWithSmsBloc>().add(
                              LoginWithSmsSecCodeRequested(widget.form.phone));
                        },
                      );
                    },
                  );
                },
          child: leftSecond == 0
              ? const Text('获取短信验证码')
              : Text('重新获取(${leftSecond}s)'),
        );
      },
    );
  }
}

class SecCodeDialog extends StatefulWidget {
  final String phone;
  final Function(String) onSecCode;
  final Function onPressed;

  const SecCodeDialog({
    super.key,
    required this.phone,
    required this.onSecCode,
    required this.onPressed,
  });

  @override
  State<StatefulWidget> createState() => SecCodeDialogState();
}

class SecCodeDialogState extends State<SecCodeDialog> {
  LoginParam? _loginParam;
  Uint8List? _secCodeData;

  String? _secCode;

  late Future<void> _future;

  @override
  void initState() {
    _future = _getSecCode(context);

    super.initState();
  }

  Future<void> _getSecCode(BuildContext context) async {
    final client = context.read<Keylol>();

    _loginParam ??= await client.getSmsLoginParam(widget.phone);

    _loginParam!.genIdHash();
    _secCodeData = await client.getSecCode(
        update: _loginParam!.update, idHash: _loginParam!.idHash);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('验证码'),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(
                    AppLocalizations.of(context)!.loginPageInputLabelSecCode),
              ),
              validator: (secCode) {
                if (secCode == null || secCode.isEmpty) {
                  return AppLocalizations.of(context)!
                      .loginPageInputSecCodeEmpty;
                }
                return null;
              },
              onSaved: (secCode) => _secCode = secCode!,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (_secCodeData == null) {
                  return const SizedBox(
                    width: 140,
                  );
                }
                return InkWell(
                  child: Image.memory(
                    _secCodeData!,
                    fit: BoxFit.fill,
                  ),
                  onTap: () {
                    setState(() {
                      _future = _getSecCode(context);
                    });
                  },
                );
              },
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          child: Text('确定'),
          onPressed: () {
            widget.onSecCode(_secCode!);

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
