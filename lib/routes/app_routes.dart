import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeropass/presentation/pages/auth/forgot_password.dart';
import 'package:zeropass/presentation/pages/auth/login_page.dart';
import 'package:zeropass/presentation/pages/auth/register_page.dart';
import 'package:zeropass/presentation/pages/splash/splash_page.dart';
import 'package:zeropass/presentation/pages/welcome/welcome_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: '/forgot-password',
            builder: (context, state) => const ForgotPassword(),
          ),
        ],
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
    ],
  );
}
