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
      body: child,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.onSurface.withOpacity(.5),
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        onTap: (index) => provider.setTab(context, index),
        items: [
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome11,
              color: currentIndex == 0
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(.5),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedDashboardSquare02,
              color: currentIndex == 1
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(.5),
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedAddCircleHalfDot,
              color: currentIndex == 2
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(.5),
            ),
            label: 'Add Password',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedAiMagic,
              color: currentIndex == 3
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(.5),
            ),
            label: 'Generate',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedUserCircle02,
              color: currentIndex == 4
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(.5),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
