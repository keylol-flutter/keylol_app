import 'package:flutter/material.dart';
import 'package:keylol_flutter/screen/forum/forum_page.dart';
import 'package:keylol_flutter/screen/home/home_page.dart';
import 'package:keylol_flutter/screen/login/login_page.dart';
import 'package:keylol_flutter/screen/thread/thread_page.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomePage(),
  '/login': (context) => const LoginPage(),
  '/forum': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return ForumPage(fid: args['fid']);
  },
  '/thread': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return ThreadPage(tid: args['tid']);
  }
};
