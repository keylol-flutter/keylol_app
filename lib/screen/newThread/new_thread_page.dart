import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/authentication/authentication_bloc.dart';

class NewThreadPage extends StatefulWidget {
  final String? fid;

  const NewThreadPage({super.key, this.fid});

  @override
  State<StatefulWidget> createState() => _NewThreadPageState();
}

class _NewThreadPageState extends State<NewThreadPage> {
  late final Keylol _client;
  late final CookieManager _cookieManager;

  @override
  void initState() {
    _client = context.read<Keylol>();
    _cookieManager = CookieManager.instance();

    super.initState();
  }

  Future<void> _setCookies() async {
    final url = WebUri('https://keylol.com');
    final cookies = await _client.cookies();
    for (final cookie in cookies) {
      cookie.forEach((name, value) {
        _cookieManager.setCookie(url: url, name: name, value: value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return FutureBuilder(
          future: _setCookies(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            late final String url;
            if (widget.fid == null) {
              url = 'https://keylol.com/forum.php?mod=misc&action=nav&mobile=2';
            } else {
              url =
                  'https://keylol.com/forum.php?mod=post&actin=newThread&special=3&fid=${widget.fid}&cedit=yes&extra=';
            }

            return Scaffold(
              appBar: AppBar(),
              body: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(url)),
              ),
            );
          },
        );
      },
    );
  }
}
