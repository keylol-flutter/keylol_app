import 'package:flutter/material.dart';
import 'package:keylol_flutter/screen/index/index_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _index = 0;
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          IndexPage(),
        ],
      ),
      drawer: _buildDrawer(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final destinations = <NavigationDrawerDestination>[
      NavigationDrawerDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: Text(
          AppLocalizations.of(context)!.homePageDrawerListTileHome,
        ),
      )
    ];

    return NavigationDrawer(
      selectedIndex: -1,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            AppLocalizations.of(context)!.homePageDrawerHeader,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        for (final destination in destinations) destination,
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: _index,
      onTap: (index) {
        setState(() {
          _index = index;
          _controller.animateToPage(
            index,
            duration: const Duration(microseconds: 500),
            curve: Curves.linear,
          );
        });
      },
      items: [
        SalomonBottomBarItem(
          icon: const Icon(
            Icons.home_outlined,
          ),
          activeIcon: const Icon(
            Icons.home,
          ),
          title: const Text('聚焦'),
        ),
        SalomonBottomBarItem(
          icon: const Icon(
            Icons.camera_outlined,
          ),
          activeIcon: const Icon(
            Icons.camera,
          ),
          title: const Text('导读'),
        ),
        SalomonBottomBarItem(
          icon: const Icon(
            Icons.dashboard_outlined,
          ),
          activeIcon: const Icon(
            Icons.dashboard,
          ),
          title: const Text('版块'),
        ),
      ],
    );
  }
}
