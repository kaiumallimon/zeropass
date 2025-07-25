import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/data/local_db/local_db_service.dart';
import 'package:zeropass/presentation/providers/categorized_passwords_provider.dart';
import 'package:zeropass/presentation/providers/dashboard_wrapper_provider.dart';
import 'package:zeropass/presentation/providers/home_provider.dart';
import 'package:zeropass/presentation/providers/totp_provider.dart';

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HomeProvider>().init(context);
        // Initialize TOTP provider to start the timer for latest TOTP entries
        context.read<TotpProvider>().loadTotpEntries(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = LocalDatabaseService.getProfile();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<HomeProvider>().init(context);
          },
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
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                ),
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
                                  context
                                      .read<DashboardWrapperProvider>()
                                      .setTab(context, 1);
                                },
                                child: Text(
                                  'View All',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary
                                        .withOpacity(.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildLatestPasswordsList(),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Latest Categories',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<DashboardWrapperProvider>()
                                      .setTab(context, 2);
                                },
                                child: Text(
                                  'View All',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary
                                        .withOpacity(.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildLatestCategoriesList(),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Latest TOTP',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<DashboardWrapperProvider>()
                                      .setTab(context, 3);
                                },
                                child: Text(
                                  'View All',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary
                                        .withOpacity(.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildLatestTotpList(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLatestPasswordsList() {
    final theme = Theme.of(context);
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingPasswords) {
          return SizedBox(
            height: 200,
            child: const Center(child: CupertinoActivityIndicator()),
          );
        }

        if (provider.passwords.isEmpty) {
          return const Center(child: Text('No passwords found.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.passwords.length,
          itemBuilder: (context, index) {
            // final password = provider.passwords[index];
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
                  context.read<CategorizedPasswordsProvider>().deletePassword(
                    provider.passwords[index].id,
                  );
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
                            Clipboard.setData(
                              ClipboardData(
                                text: provider.passwords[index].password,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Password copied to clipboard',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                backgroundColor: theme.colorScheme.primary,
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
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
          },
        );
      },
    );
  }

  Widget _buildLatestCategoriesList() {
    final theme = Theme.of(context);
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return SizedBox(
            height: 200,
            child: const Center(child: CupertinoActivityIndicator()),
          );
        }

        if (provider.categories.isEmpty) {
          return const Center(child: Text('No categories found.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.categories.length,
          itemBuilder: (context, index) {
            final category = provider.categories[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  context.read<DashboardWrapperProvider>().setTab(
                    context,
                    1,
                    shouldGo: false,
                  );
                  context.go(
                    "/categories/categorized-passwords",
                    extra: {
                      'categoryId': category['id'],
                      'categoryName': category['name'],
                      'from': 'home',
                    },
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
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withOpacity(.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            category['name']?.substring(0, 1)?.toUpperCase() ??
                                '?',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category['name'] ?? 'Unknown Category',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: theme.colorScheme.onSurface.withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLatestTotpList() {
    final theme = Theme.of(context);
    return Consumer<TotpProvider>(
      builder: (context, totpProvider, _) {
        if (totpProvider.isLoading) {
          return SizedBox(
            height: 200,
            child: const Center(child: CupertinoActivityIndicator()),
          );
        }

        if (totpProvider.totpEntries.isEmpty) {
          return const Center(child: Text('No TOTP entries found.'));
        }

        // Show only the first 5 entries for "Latest TOTP"
        final latestEntries = totpProvider.totpEntries.take(5).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: latestEntries.length,
          itemBuilder: (context, index) {
            final entry = latestEntries[index];
            final otp = totpProvider.currentOtps[entry.id] ?? '••••••';

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  context.read<DashboardWrapperProvider>().setTab(context, 3);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: otp));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          margin: EdgeInsets.all(10),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: theme.colorScheme.primaryContainer,
                          content: Text(
                            'OTP copied to clipboard',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: theme.colorScheme.onSurface.withOpacity(.1),
                        width: 1,
                      ),
                    ),
                    // tileColor: theme.colorScheme.primary.withOpacity(.1),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.issuer == entry.name
                              ? entry.issuer
                              : '${entry.issuer} (${(entry.name).split(':').last})',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          otp,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    trailing: Consumer<TotpProvider>(
                      builder: (context, provider, _) {
                        final remaining = provider.secondsRemaining;
                        final progress = remaining / 30;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 4,
                                color: theme.colorScheme.primary,
                                backgroundColor: theme.colorScheme.onSurface
                                    .withOpacity(0.1),
                              ),
                            ),
                            Text(
                              remaining.toString(),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
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
