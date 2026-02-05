import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootNavigation extends StatelessWidget {
  final Widget child;
  const RootNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;

    if (location.startsWith('/search')) currentIndex = 1;
    if (location.startsWith('/roster')) currentIndex = 2;
    if (location.startsWith('/settings')) currentIndex = 3;

    // Hide navigation bar on splash screen
    final showNavigation = !location.startsWith('/splash');

    return Scaffold(
      body: child,
      bottomNavigationBar: showNavigation
          ? NavigationBar(
              backgroundColor: kIsWeb
                  ? Theme.of(context).colorScheme.surface.withAlpha(130)
                  : null,
              selectedIndex: currentIndex,
              onDestinationSelected: (int index) {
                switch (index) {
                  case 0:
                    context.go('/home');
                    break;
                  case 1:
                    context.go('/search');
                    break;
                  case 2:
                    context.go('/roster');
                    break;
                  case 3:
                    context.go('/settings');
                    break;
                }
              },
              destinations: [
                NavigationDestination(
                  icon: Semantics(
                    label: 'Home',
                    child: const Icon(Icons.home_outlined),
                  ),
                  selectedIcon: Semantics(
                    label: 'Home, selected',
                    child: const Icon(Icons.home),
                  ),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Semantics(
                    label: 'Search',
                    child: const Icon(Icons.search_outlined),
                  ),
                  selectedIcon: Semantics(
                    label: 'Search, selected',
                    child: const Icon(Icons.search),
                  ),
                  label: 'Search',
                ),
                NavigationDestination(
                  icon: Semantics(
                    label: 'Roster',
                    child: const Icon(Icons.group_outlined),
                  ),
                  selectedIcon: Semantics(
                    label: 'Roster, selected',
                    child: const Icon(Icons.group),
                  ),
                  label: 'Roster',
                ),
                NavigationDestination(
                  icon: Semantics(
                    label: 'Settings',
                    child: const Icon(Icons.settings_outlined),
                  ),
                  selectedIcon: Semantics(
                    label: 'Settings, selected',
                    child: const Icon(Icons.settings),
                  ),
                  label: 'Settings',
                ),
              ],
            )
          : null,
    );
  }
}
