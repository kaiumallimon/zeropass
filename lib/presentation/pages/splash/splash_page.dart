import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/core/constants/app_assets.dart';
import 'package:zeropass/core/constants/app_strings.dart';
import 'package:zeropass/presentation/providers/splash_provider.dart';
import 'package:zeropass/presentation/providers/theme_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        // Navigate to the next page after the splash screen
        if (context.mounted) {
          context.read<SplashProvider>().navigate(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    SystemChrome.setSystemUIOverlayStyle(
      context.read<ThemeProvider>().getOverlayStyle(context),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _CenteredContent(theme: theme),

            _BottomContent(theme: theme),
          ],
        ),
      ),
    );
  }
}

class _BottomContent extends StatelessWidget {
  const _BottomContent({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.splashMessage,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              fontSize: 14,
              fontFamily: 'Sora',
            ),
          ),
          const SizedBox(height: 20),
          CupertinoActivityIndicator(color: theme.colorScheme.primary),
        ],
      ),
    );
  }
}

class _CenteredContent extends StatelessWidget {
  const _CenteredContent({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Image.asset(
            AppAssets.logo,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              text: AppStrings.appName1,
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontFamily: 'Sora',
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: AppStrings.appName2,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
