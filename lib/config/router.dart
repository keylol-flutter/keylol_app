import 'package:flutter/material.dart';
import 'package:keylol_flutter/screen/home/home_page.dart';
import 'package:keylol_flutter/screen/login/login_page.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomePage(),
  '/login': (context) => const LoginPage(),
};
