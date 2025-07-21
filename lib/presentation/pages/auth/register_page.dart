import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeropass/core/constants/app_assets.dart';
import 'package:zeropass/core/constants/app_strings.dart';
import 'package:zeropass/shared/widgets/custom_button.dart';
import 'package:zeropass/shared/widgets/custom_textfield.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  AppStrings.registerTitle,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppStrings.registerSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),

                const SizedBox(height: 30),

                // Name TextField
                CustomTextField(
                  label: 'Name',
                  hintText: 'Enter your name',
                  keyboardType: TextInputType.name,
                ),

                const SizedBox(height: 20),

                // Email TextField
                CustomTextField(
                  label: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                // Password TextField
                CustomTextField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),

                const SizedBox(height: 30),

                CustomButton(
                  text: 'Register',
                  width: double.infinity,
                  onPressed: () {},
                ),

                const SizedBox(height: 30),

                // Already have an account
                Center(
                  child: Text(
                    'Already have an account? ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      context.go('/login');
                    },
                    child: Text(
                      'Login',
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
