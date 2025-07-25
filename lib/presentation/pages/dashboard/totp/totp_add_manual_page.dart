import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/presentation/providers/totp_provider.dart';
import 'package:zeropass/shared/widgets/custom_button.dart';
import 'package:zeropass/shared/widgets/custom_textfield.dart';

class TotpAddManualPage extends StatelessWidget {
  const TotpAddManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final totpProvider = context.watch<TotpProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: theme.colorScheme.surface,
        toolbarHeight: 80,
        title: const Text('Add Service Manually'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Name',
                hintText: 'Enter service/app name',
                keyboardType: TextInputType.text,
                controller: totpProvider.nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Secret',
                hintText: 'Enter TOTP secret key',
                keyboardType: TextInputType.text,
                controller: totpProvider.secretController,
              ),
              const SizedBox(height: 20),

              CustomTextField(
                label: 'Issuer',
                hintText: 'Enter issuer',
                keyboardType: TextInputType.text,
                controller: totpProvider.issuerController,
              ),
              const SizedBox(height: 20),

              Consumer<TotpProvider>(
                builder: (context, provider, child) {
                  return CustomButton(
                    text: 'Add TOTP',
                    width: double.infinity,
                    isLoading: provider.isLoading,
                    onPressed: () async {
                      final response = await provider.manualEntry(context);
                      if (response) {
                        context.pop();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
