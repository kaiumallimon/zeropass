import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zeropass/presentation/providers/dashboard_wrapper_provider.dart';

class DashboardWrapper extends StatelessWidget {
  const DashboardWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardWrapperProvider>();
    final currentLocation = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.selectedIndex,
        onTap: (index) => provider.setTab(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
