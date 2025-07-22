import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeropass/presentation/pages/auth/forgot_password.dart';
import 'package:zeropass/presentation/pages/auth/login_page.dart';
import 'package:zeropass/presentation/pages/auth/register_page.dart';
import 'package:zeropass/presentation/pages/dashboard/dashboard_wrapper.dart';
import 'package:zeropass/presentation/pages/dashboard/home/home_page.dart';
import 'package:zeropass/presentation/pages/dashboard/profile/profile_page.dart';
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

      ShellRoute(
        builder: (context, state, child) {
          return DashboardWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ProfilePage(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(opacity: animation, child: child);
}

// Widget _slideFromRightTransition(
//   BuildContext context,
//   Animation<double> animation,
//   Animation<double> secondaryAnimation,
//   Widget child,
// ) {
//   return SlideTransition(
//     position: Tween<Offset>(
//       begin: const Offset(1, 0),
//       end: Offset.zero,
//     ).animate(animation),
//     child: child,
//   );
// }

// Widget _slideUpFadeTransition(
//   BuildContext context,
//   Animation<double> animation,
//   Animation<double> secondaryAnimation,
//   Widget child,
// ) {
//   return SlideTransition(
//     position: Tween<Offset>(
//       begin: const Offset(0, 0.1),
//       end: Offset.zero,
//     ).animate(animation),
//     child: FadeTransition(opacity: animation, child: child),
//   );
// }
