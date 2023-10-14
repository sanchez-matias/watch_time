import 'package:watch_time/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

// Our HomeScreen widget will just set a Scaffold and the NavigationBar. The
// rest of the content will be displayed by its possible children.
class HomeScreen extends StatelessWidget {
  static const name = 'homescreen';
  final Widget childView;

  const HomeScreen({
    super.key,
    required this.childView,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: childView,
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
