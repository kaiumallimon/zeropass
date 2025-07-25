import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/data/local_db/local_db_service.dart';
import 'package:zeropass/presentation/providers/dashboard_wrapper_provider.dart';
import 'package:zeropass/presentation/providers/home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      context.read<HomeProvider>().init(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = LocalDatabaseService.getProfile();

    return Scaffold(
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: theme.colorScheme.surface,
                  foregroundColor: theme.colorScheme.onSurface,
                  elevation: 0,
                  toolbarHeight: 100,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'Welcome,\n',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                              children: [
                                TextSpan(
                                  text: profile?.name ?? 'User',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/home/profile'),
                          child: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary
                                .withOpacity(0.3),
                            radius: 25,
                            child: Text(
                              (profile?.name.isNotEmpty ?? false)
                                  ? profile!.name[0].toUpperCase()
                                  : '?',
                              style: theme.textTheme.headlineSmall?.copyWith(
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (provider.isLoading) ...[
                          const LinearProgressIndicator(),
                          const SizedBox(height: 20),
                        ],
                        Row(
                          children: [
                            _buildStatCard(
                              title: 'Passwords',
                              count: provider.passwordsCount,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 15),
                            _buildStatCard(
                              title: 'TOTP Entries',
                              count: provider.authenticatorsCount,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                        if (provider.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'Error: ${provider.errorMessage}',
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Latest Passwords',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<DashboardWrapperProvider>().setTab(
                                  context,
                                  1,
                                );
                              },
                              child: Text(
                                'View All',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary.withOpacity(
                                    .7,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildLatestPasswordsList(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLatestPasswordsList() {
    final theme = Theme.of(context);
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingPasswords) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.passwords.isEmpty) {
          return const Center(child: Text('No passwords found.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.passwords.length,
          itemBuilder: (context, index) {
            final password = provider.passwords[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Dismissible(
                key: Key(provider.passwords[index].id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  // Optional: Confirm before deleting
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Password?'),
                      content: const Text(
                        'Are you sure you want to delete this password?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },

                onDismissed: (direction) {
                  // Delete the password
                  // provider.deletePassword(
                  //   provider.categorizedPasswords[index]['id'],
                  // );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Password Deleted',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.errorContainer,

                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    context.go(
                      "/categories/categorized-passwords/details",
                      extra: provider.passwords[index].toJson()
                        ..addAll({
                          'categoryId': provider.passwords[index].categoryId,
                          'from': 'home',
                        }),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: theme.colorScheme.onSurface.withOpacity(.1),
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
                                  color: theme.colorScheme.primary.withOpacity(
                                    .15,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    provider.passwords[index].name
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize:
                                      MainAxisSize.min, // allow dynamic height
                                  children: [
                                    Text(
                                      provider.passwords[index].name,
                                      style: theme.textTheme.bodySmall,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      provider.passwords[index].username,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(.7),
                                          ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () async {
                            // await provider.copyPassword(
                            //   context,
                            //   index,
                            // );
                          },
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedCopy01,
                            color: theme.colorScheme.primary,
                            size: 23,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            ;
          },
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
