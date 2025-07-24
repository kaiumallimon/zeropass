import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/presentation/providers/dashboard_wrapper_provider.dart';

class DashboardWrapper extends StatelessWidget {
  const DashboardWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardWrapperProvider>();
    final currentLocation = GoRouterState.of(context).uri.toString();
    final theme = Theme.of(context);
    final currentIndex = provider.tabs.indexWhere(
      (tab) => currentLocation.startsWith(tab),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: child,
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: theme.colorScheme.surface,
        selectedIndex: provider.selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: theme.colorScheme.primary,

        onDestinationSelected: (value) {
          provider.setTab(context, value);
        },
        destinations: [
          NavigationDestination(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome11,
              color: currentIndex == 0
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withOpacity(.5),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedDashboardSquare02,
              color: currentIndex == 1
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withOpacity(.5),
            ),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedAddCircleHalfDot,
              color: currentIndex == 2
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withOpacity(.5),
            ),
            label: 'Add',
          ),
          NavigationDestination(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedAiMagic,
              color: currentIndex == 3
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withOpacity(.5),
            ),
            label: 'Generate',
          ),
          NavigationDestination(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedShield01,
              color: currentIndex == 4
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withOpacity(.5),
            ),
            label: 'TOTP',
          ),
        ],
      ),
    );
  }
}
