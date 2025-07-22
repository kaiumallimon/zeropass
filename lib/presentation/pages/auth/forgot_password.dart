import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/core/constants/app_assets.dart';
import 'package:zeropass/presentation/providers/forgotpassword_provider.dart';
import 'package:zeropass/shared/widgets/custom_button.dart';
import 'package:zeropass/shared/widgets/custom_textfield.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppAssets.logo, // Replace with your logo asset
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 50),
                  IconButton.outlined(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowLeft01,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      side: WidgetStateProperty.all<BorderSide>(
                        BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                    ),
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 20),
                  // Title and Subtitle
                  Text(
                    'Forgot Password',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter your email to reset your password',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Email TextField
                  CustomTextField(
                    hintText: 'Your email address',
                    keyboardType: TextInputType.emailAddress,
                    controller: context
                        .watch<ForgotpasswordProvider>()
                        .emailController,
                  ),

                  const SizedBox(height: 20),

                  // Reset Password Button
                  Consumer<ForgotpasswordProvider>(
                    builder: (context, provider, child) {
                      return CustomButton(
                        text: 'Reset Password',
                        width: double.infinity,
                        isLoading: provider.isLoading,
                        onPressed: () async =>
                            await provider.resetPassword(context),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
