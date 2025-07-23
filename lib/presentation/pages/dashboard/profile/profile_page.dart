import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/presentation/providers/profile_provider.dart';
import 'package:zeropass/shared/widgets/custom_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = context.watch<ProfileProvider>().profile;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: profile == null
            ? Center(
                child: Text(
                  'No profile found.',
                  style: theme.textTheme.titleMedium,
                ),
              )
            : CustomScrollView(
                slivers: [
                  _buildAppBar(theme),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildProfileHeader(context, profile),
                          const SizedBox(height: 30),
                          _buildProfileMenu(context),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: "Logout",
                            onPressed: () {
                              context.read<ProfileProvider>().logout(context);
                            },
                            color: theme.colorScheme.errorContainer,
                            textColor: theme.colorScheme.onErrorContainer,
                            width: double.infinity,
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedLogout01,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    return SliverAppBar(
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      elevation: 0,
      shadowColor: theme.colorScheme.surface,
      surfaceTintColor: theme.colorScheme.surface,
      toolbarHeight: 80,
      title: Text('Profile'),
      pinned: true,
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic profile) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withOpacity(.3),
          radius: 65,
          child: Text(
            profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
            style: theme.textTheme.displayMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          profile.name.isNotEmpty ? profile.name : 'No Name',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          profile.email.isNotEmpty ? profile.email : 'No Email',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      _ProfileMenuItem(
        icon: HugeIcons.strokeRoundedUser02,
        label: 'Edit Profile',
        onTap: () {
          // Navigate to edit profile
        },
      ),
      _ProfileMenuItem(
        icon: HugeIcons.strokeRoundedLockPassword,
        label: 'Change Password',
        onTap: () {
          // Navigate to change password
        },
      ),
      _ProfileMenuItem(
        icon: HugeIcons.strokeRoundedMoon02,
        label: 'Dark Mode',
        onTap: () {
          context.go('/profile/theme');
        },
      ),
      _ProfileMenuItem(
        icon: HugeIcons.strokeRoundedInformationCircle,
        label: 'About',
        onTap: () {},
      ),
      _ProfileMenuItem(
        icon: HugeIcons.strokeRoundedHelpCircle,
        label: 'Help & Support',
        onTap: () {},
      ),
      _ProfileMenuItem(
        icon: HugeIcons.strokeRoundedPoliceBadge,
        label: 'Privacy Policy',
        onTap: () {},
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.15),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: HugeIcon(
                icon: items[i].icon,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                items[i].label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              onTap: items[i].onTap,
              trailing: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: theme.colorScheme.primary.withOpacity(0.4),
              ),
            ),
            // if (i < items.length - 1)
            //   Container(
            //     height: 1,
            //     color: theme.colorScheme.onSurface.withOpacity(0.1),
            //     margin: const EdgeInsets.symmetric(horizontal: 16),
            //   ),
          ],
        ],
      ),
    );
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
