import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavigation({
    super.key,
    required this.selectedIndex,
  });

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home/0');
        break;
      case 1:
        context.go('/home/1');
        break;
      case 2:
        context.go('/home/2');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      elevation: 0.8,
      selectedIndex: selectedIndex,
      onDestinationSelected: (value) => onItemTapped(context, value),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_filled), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.list), label: 'Watchlist'),
        NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
      ],
    );
  }
}
