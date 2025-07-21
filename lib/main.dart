import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/core/theme/app_theme.dart';
import 'package:zeropass/presentation/providers/splash_provider.dart';
import 'package:zeropass/presentation/providers/welcome_provider.dart';
import 'package:zeropass/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add your providers here, e.g.:
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => WelcomeProvider()),

        // ChangeNotifierProvider(create: (_) => AnotherProvider()),
      ],
      child: MaterialApp.router(
        title: 'ZeroPass',
        debugShowCheckedModeBanner: true,
        theme: AppTheme.lightTheme,
        routerDelegate: AppRoutes.router.routerDelegate,
        routeInformationParser: AppRoutes.router.routeInformationParser,
        routeInformationProvider: AppRoutes.router.routeInformationProvider,
      ),
    );
  }
}
