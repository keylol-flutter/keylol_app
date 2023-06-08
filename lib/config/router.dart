import 'package:go_router/go_router.dart';
import 'package:keylol_flutter/screen/home/home_page.dart';
import 'package:keylol_flutter/screen/login/login_page.dart';

final routerConfig = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
