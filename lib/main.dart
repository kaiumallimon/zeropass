import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zeropass/data/local_db/local_db_service.dart';
import 'package:zeropass/presentation/providers/add_category_provider.dart';
import 'package:zeropass/presentation/providers/add_password_provider.dart';
import 'package:zeropass/presentation/providers/categorized_passwords_provider.dart';
import 'package:zeropass/presentation/providers/category_provider.dart';
import 'package:zeropass/presentation/providers/dashboard_wrapper_provider.dart';
import 'package:zeropass/presentation/providers/detailed_password_provider.dart';
import 'package:zeropass/presentation/providers/forgotpassword_provider.dart';
import 'package:zeropass/presentation/providers/login_provider.dart';
import 'package:zeropass/presentation/providers/profile_provider.dart';
import 'package:zeropass/presentation/providers/registration_provider.dart';
import 'package:zeropass/presentation/providers/splash_provider.dart';
import 'package:zeropass/presentation/providers/theme_provider.dart';
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
  await Supabase.initialize(
    url: supabaseUrl!,
    anonKey: supabaseKey!,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  /// initialize local database service
  await LocalDatabaseService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => WelcomeProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ForgotpasswordProvider()),
        ChangeNotifierProvider(create: (_) => DashboardWrapperProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AddCategoryProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider<AddPasswordProvider>(
          create: (context) =>
              AddPasswordProvider(context.read<CategoryProvider>()),
        ),

        ChangeNotifierProvider(create: (_) => CategorizedPasswordsProvider()),
        ChangeNotifierProvider(create: (_) => DetailedPasswordProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    
    return MaterialApp.router(
      title: 'ZeroPass',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      routerDelegate: AppRoutes.router.routerDelegate,
      routeInformationParser: AppRoutes.router.routeInformationParser,
      routeInformationProvider: AppRoutes.router.routeInformationProvider,
    );
  }
}
