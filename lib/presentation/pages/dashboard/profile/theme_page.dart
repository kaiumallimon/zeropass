import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/presentation/providers/theme_provider.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        shadowColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surface,
        toolbarHeight: 80,
        title: const Text('Theme Settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Column(
            children: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return ListTile(
                    title: const Text('Dark Mode'),
                    onTap: () {
                      themeProvider.toggleTheme();
                    },
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                    ),
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
