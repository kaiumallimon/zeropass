import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/presentation/providers/categorized_passwords_provider.dart';
import 'package:zeropass/shared/widgets/custom_textfield.dart';

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

    // Fetch passwords for the given category when the page is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CategorizedPasswordsProvider>(
        context,
        listen: false,
      ).fetchPasswords(categoryId);
    });

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
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<CategorizedPasswordsProvider>(
            context,
            listen: false,
          ).fetchPasswords(categoryId);
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child: Column(
              children: [
                Consumer<CategorizedPasswordsProvider>(
                  builder: (context, provider, child) {
                    return Container(
                      key: Key(categoryId),
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity(.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: provider.isLoading
                            ? CupertinoActivityIndicator(
                                color: theme.colorScheme.primary,
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${provider.categorizedPasswords.length}',
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),

                                  SizedBox(height: 5),

                                  Text(
                                    'Passwords Stored',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(.5),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Search Passwords',
                  keyboardType: TextInputType.text,
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.onSurface.withOpacity(.5),
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: Consumer<CategorizedPasswordsProvider>(
                    builder: (context, provider, child) {
                      return ListView.builder(
                        key: Key(categoryId),
                        itemCount: provider.categorizedPasswords.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(8),

                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  .1,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary
                                              .withOpacity(.15),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            provider
                                                .categorizedPasswords[index]['name']
                                                .substring(0, 1)
                                                .toUpperCase(),
                                            style: theme
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                  color:
                                                      theme.colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            provider
                                                .categorizedPasswords[index]['name'],
                                            style: theme.textTheme.titleSmall,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            provider
                                                .categorizedPasswords[index]['username'],

                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(.7),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                IconButton(
                                  onPressed: () async {
                                    await provider.copyPassword(context, index);
                                  },
                                  icon: HugeIcon(
                                    icon: HugeIcons.strokeRoundedCopy01,
                                    color: theme.colorScheme.primary,
                                    size: 23,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
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
