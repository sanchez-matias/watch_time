import 'package:watch_time/presentation/views/views.dart';
import 'package:watch_time/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

// This is now a statefull widget which implements an AutomaticKeepAliveClientMixin
// to keep the state of the different pages and widgets of our homescreen.
class HomeScreen extends StatefulWidget {
  static const name = 'home_screen';
  final int pageIndex;

  const HomeScreen({
    super.key,
    required this.pageIndex,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      keepPage: true,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final viewItems = const <Widget>[
    HomeView(),
    WatchlistView(),
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (pageController.hasClients) {
      pageController.animateToPage(
        widget.pageIndex,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250),
      );
    }

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: viewItems,
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: widget.pageIndex,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
