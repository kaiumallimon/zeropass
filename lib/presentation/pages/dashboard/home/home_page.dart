import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeropass/data/local_db/local_db_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final profile = LocalDatabaseService.getProfile();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              elevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              toolbarHeight: 100,
              title: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  spacing: 20,
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
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        context.go('/profile');
                      },
                      child: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary.withOpacity(
                          .3,
                        ),
                        radius: 25,
                        child: Text(
                          profile!.name.isNotEmpty
                              ? profile.name[0].toUpperCase()
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
            // Add your dashboard content here
          ],
        ),
      ),
    );
  }
}
