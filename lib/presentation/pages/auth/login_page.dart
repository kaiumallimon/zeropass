import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/core/constants/app_assets.dart';
import 'package:zeropass/core/constants/app_strings.dart';
import 'package:zeropass/presentation/providers/login_provider.dart';
import 'package:zeropass/shared/widgets/custom_button.dart';
import 'package:zeropass/shared/widgets/custom_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  AppAssets.logo,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 50),

                // Title and Subtitle
                Text(
                  AppStrings.loginTitle,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppStrings.loginSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),

                const SizedBox(height: 30),

                // Email TextField
                CustomTextField(
                  label: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  controller: loginProvider.emailController,
                ),

                const SizedBox(height: 20),

                // Password TextField
                CustomTextField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  controller: loginProvider.passwordController,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to Forgot Password Page
                        context.go('/login/forgot-password');
                      },
                      child: Text(
                        AppStrings.forgotPassword,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Consumer<LoginProvider>(
                  builder: (context, provider, child) {
                    return CustomButton(
                      text: 'Login',
                      width: double.infinity,
                      isLoading: provider.isLoading,
                      onPressed: () async => provider.login(context),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Already have an account
                Center(
                  child: Text(
                    'Don\'t have an account yet?',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      context.go('/register');
                    },
                    child: Text(
                      'Register Now',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
