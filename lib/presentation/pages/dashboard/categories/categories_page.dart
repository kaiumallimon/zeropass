import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        toolbarHeight: 80,
        title: Text('Categories'),
      ),
      body: SafeArea(child: Center(child: Text('Categories Page'))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/categories/add-category');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
