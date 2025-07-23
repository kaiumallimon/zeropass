import 'package:flutter/material.dart';

class CategorizedPasswordsPage extends StatelessWidget {
  const CategorizedPasswordsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  final String categoryId;
  final String categoryName;

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
        title: Text('$categoryName Passwords'),
      ),
      body: SafeArea(child: Center(child: Text('Categorized Passwords Page'))),
    );
  }
}
