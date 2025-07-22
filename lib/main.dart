import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zeropass/core/theme/app_theme.dart';
import 'package:zeropass/presentation/providers/forgotpassword_provider.dart';
import 'package:zeropass/presentation/providers/registration_provider.dart';
import 'package:zeropass/presentation/providers/splash_provider.dart';
import 'package:zeropass/presentation/providers/welcome_provider.dart';
import 'package:zeropass/routes/app_routes.dart';

void main() async {
  /// Ensure that Flutter bindings are initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  /// Load environment variables
  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];

  /// Supabase SDK init
  await Supabase.initialize(url: supabaseUrl!, anonKey: supabaseKey!);

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
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => ForgotpasswordProvider()),


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
