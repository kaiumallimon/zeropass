import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeropass/presentation/pages/auth/forgot_password.dart';
import 'package:zeropass/presentation/pages/auth/login_page.dart';
import 'package:zeropass/presentation/pages/auth/register_page.dart';
import 'package:zeropass/presentation/pages/dashboard/add_password/add_password.dart';
import 'package:zeropass/presentation/pages/dashboard/categories/add_categories_page.dart';
import 'package:zeropass/presentation/pages/dashboard/categories/categories_page.dart';
import 'package:zeropass/presentation/pages/dashboard/categories/categorized_passwords.dart';
import 'package:zeropass/presentation/pages/dashboard/categories/password_details_page.dart';
import 'package:zeropass/presentation/pages/dashboard/dashboard_wrapper.dart';
import 'package:zeropass/presentation/pages/dashboard/generator/password_generator_page.dart';
import 'package:zeropass/presentation/pages/dashboard/home/home_page.dart';
import 'package:zeropass/presentation/pages/dashboard/profile/profile_page.dart';
import 'package:zeropass/presentation/pages/dashboard/profile/theme_page.dart';
import 'package:zeropass/presentation/pages/dashboard/profile/about_page.dart';
import 'package:zeropass/presentation/pages/dashboard/profile/help_support_page.dart';
import 'package:zeropass/presentation/pages/dashboard/profile/privacy_policy_page.dart';
import 'package:zeropass/presentation/pages/dashboard/profile/change_password_page.dart';
import 'package:zeropass/presentation/pages/dashboard/profile/edit_profile_page.dart';
import 'package:zeropass/presentation/pages/dashboard/totp/totp_add_manual_page.dart';
import 'package:zeropass/presentation/pages/dashboard/totp/totp_page.dart';
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
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ProfilePage(),
                  transitionsBuilder: _fadeTransition,
                ),
                // Add the ThemePage route
                routes: [
                  GoRoute(
                    path: '/theme',
                    builder: (context, state) => const ThemePage(),
                  ),
                  GoRoute(
                    path: '/edit-profile',
                    builder: (context, state) => const EditProfilePage(),
                  ),
                  GoRoute(
                    path: '/change-password',
                    builder: (context, state) => const ChangePasswordPage(),
                  ),
                  GoRoute(
                    path: '/about',
                    builder: (context, state) => const AboutPage(),
                  ),
                  GoRoute(
                    path: '/help-support',
                    builder: (context, state) => const HelpSupportPage(),
                  ),
                  GoRoute(
                    path: '/privacy-policy',
                    builder: (context, state) => const PrivacyPolicyPage(),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/categories',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const CategoriesPage(),
              transitionsBuilder: _fadeTransition,
            ),

            routes: [
              GoRoute(
                path: '/add-category',
                builder: (context, state) {
                  return const AddCategoriesPage();
                },
              ),
              GoRoute(
                path: '/categorized-passwords',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>;
                  final categoryId = extra['categoryId'] as String;
                  final categoryName = extra['categoryName'] as String;
                  final from = extra['from'] as String? ?? 'categories';

                  return CategorizedPasswordsPage(
                    categoryId: categoryId,
                    categoryName: categoryName,
                    from: from,
                  );
                },

                routes: [
                  GoRoute(
                    path: '/details',
                    builder: (context, state) {
                      final passwordData = state.extra as Map<String, dynamic>;
                      return PasswordDetailsPage(passwordData: passwordData);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/add-password',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const AddPasswordPage(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
          GoRoute(
            path: '/generator',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const PasswordGeneratorPage(),
              transitionsBuilder: _fadeTransition,
            ),
          ),

          GoRoute(
            path: '/totp',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const TotpPage(),
              transitionsBuilder: _fadeTransition,
            ),
            routes: [
              GoRoute(
                path: '/add-manual',
                builder: (context, state) => const TotpAddManualPage(),
              ),
            ],
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
