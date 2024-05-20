import 'package:flutter/material.dart';
import 'package:keylol_flutter/screen/about/app_about_page.dart';
import 'package:keylol_flutter/screen/favorite/favorite_page.dart';
import 'package:keylol_flutter/screen/forum/forum_page.dart';
import 'package:keylol_flutter/screen/history/history_page.dart';
import 'package:keylol_flutter/screen/home/home_page.dart';
import 'package:keylol_flutter/screen/login/login_page.dart';
import 'package:keylol_flutter/screen/newThread/new_thread_page.dart';
import 'package:keylol_flutter/screen/settings/settings_page.dart';
import 'package:keylol_flutter/screen/space/space_list_page.dart';
import 'package:keylol_flutter/screen/space/space_page.dart';
import 'package:keylol_flutter/screen/thread/thread_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomePage(),
  '/login': (context) => const LoginPage(),
  '/forum': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return ForumPage(fid: args['fid']);
  },
  '/thread': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return ThreadPage(
      tid: args['tid'],
      pid: args['pid'],
      thread: args['thread'],
      desktop: args['desktop'],
    );
  },
  '/newThread': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic ?? {};
    return NewThreadPage(fid: args['fid']);
  },
  '/favorite': (context) => const FavoritePage(),
  '/history': (context) => const HistoryPage(),
  '/space': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return SpacePage(uid: args['uid']);
  },
  '/space/friends': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return SpaceListPage(uid: args['uid'], initialIndex: 0);
  },
  '/space/threads': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return SpaceListPage(uid: args['uid'], initialIndex: 1);
  },
  '/space/posts': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return SpaceListPage(uid: args['uid'], initialIndex: 2);
  },
  '/settings': (context) => const SettingsPage(),
  '/about': (context) => const AppAboutPage(),
};

Future<void> urlRoute(BuildContext context, String url) async {
  url = Uri.decodeFull(url);

  {
    RegExp regExp = RegExp(r'(?:[http|https])?(?:://)?keylol.com/t(\d+)-1-1');
    if (regExp.hasMatch(url)) {
      final tid = regExp.firstMatch(url)!.group(1);
      await Navigator.of(context).pushNamed(
        '/thread',
        arguments: {
          'tid': tid,
        },
      );
      return;
    }
  }
  {
    RegExp regExp = RegExp(r'(?:[http|https])?(?:://)?keylol.com/f(\d+)-1');
    if (regExp.hasMatch(url)) {
      final fid = regExp.firstMatch(url)!.group(1);
      await Navigator.of(context).pushNamed(
        '/forum',
        arguments: {
          'fid': fid,
        },
      );
      return;
    }
  }

  launchUrlString(url);
}
