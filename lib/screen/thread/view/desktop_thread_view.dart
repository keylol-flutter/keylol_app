import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/thread/bloc/thread_bloc.dart';
import 'package:keylol_flutter/screen/thread/widgets/thread_app_bar.dart';

const String userAgent =
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36';

class DesktopThreadView extends StatefulWidget {
  const DesktopThreadView({super.key});

  @override
  State<StatefulWidget> createState() => _DesktopThreadViewState();
}

class _DesktopThreadViewState extends State<DesktopThreadView> {
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
    return BlocBuilder<ThreadBloc, ThreadState>(
      builder: (context, state) {
        final thread = state.thread!;
        final url =
            'https://keylol.com/forum.php?mod=viewthread&tid=${thread.tid}&extra=page%3D1&page=1&mobile=no';

        final appBar = ThreadAppBar(
          tid: thread.tid,
          title: thread.subject,
          favored: state.favored ?? false,
          textStyle: Theme.of(context).textTheme.titleLarge!,
          width: MediaQuery.of(context).size.width,
          topPadding: MediaQuery.of(context).padding.top,
        );

        return Scaffold(
          body: RefreshIndicator(
            edgeOffset: appBar.maxExtent,
            onRefresh: () async {
              context.read<ThreadBloc>().add(const ThreadRefreshed());
            },
            child: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: appBar,
                  )
                ];
              },
              body: FutureBuilder(
                future: _setCookies(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(url)),
                    initialSettings: InAppWebViewSettings(
                      userAgent: userAgent,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
