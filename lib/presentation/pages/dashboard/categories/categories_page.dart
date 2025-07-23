import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/presentation/providers/category_provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();

    // Fetch categories once when the page is created
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<CategoryProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Remove the fetch call from here

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        shadowColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surface,
        toolbarHeight: 80,
        title: const Text('Categories'),
      ),
      body: RefreshIndicator(
        elevation: 4,
        onRefresh: () async {
          await context.read<CategoryProvider>().fetchCategories();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Consumer<CategoryProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return Center(
                          child: CupertinoActivityIndicator(
                            color: theme.colorScheme.primary,
                          ),
                        );
                      } else if (provider.categories.isEmpty) {
                        return Center(
                          child: Text(
                            'No categories found, tap the plus icon to add a new category.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                .7,
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your passwords are categorized here. Tap on a category to view the passwords within it.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                .7,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Expanded(
                            child: GridView.builder(
                              itemCount: provider.categories.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 1.5,
                                  ),
                              itemBuilder: (context, index) {
                                final category = provider.categories[index];
                                final name = (category['name'] as String?)
                                    ?.trim();
                                final displayName =
                                    (name != null && name.isNotEmpty)
                                    ? name
                                    : 'No Name';

                                return GestureDetector(
                                  onTap: () {
                                    context.go(
                                      '/categories/categorized-passwords',
                                      extra: {
                                        'categoryId': category['id'],
                                        'categoryName': displayName,
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withOpacity(.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              '${index + 1}.',
                                              style: theme
                                                  .textTheme
                                                  .displaySmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(.3),
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            displayName,
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/categories/add-category');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
