import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/bloc/bloc/authentication_bloc.dart';
import 'package:keylol_flutter/screen/forumIndex/forum_index_page.dart';
import 'package:keylol_flutter/screen/guide/guide_page.dart';
import 'package:keylol_flutter/screen/index/index_page.dart';
import 'package:keylol_flutter/screen/notice/notice_page.dart';
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
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          drawer: _buildDrawer(context, state),
          body: PageView(
            controller: _controller,
            children: const [
              IndexPage(),
              GuidePage(),
              ForumIndexPage(),
              NoticePage(),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(context, state),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context, AuthenticationState state) {
    final destinations = <NavigationDrawerDestination>[
      NavigationDrawerDestination(
        icon: const Icon(Icons.home_outlined),
        label: Text(
          AppLocalizations.of(context)!.homePageDrawerListTileHome,
        ),
      ),
      NavigationDrawerDestination(
        icon: const Icon(Icons.star_outline_outlined),
        label: Text(
          AppLocalizations.of(context)!.homePageDrawerListTileFavorite,
        ),
      ),
      NavigationDrawerDestination(
        icon: const Icon(Icons.history_outlined),
        label: Text(
          AppLocalizations.of(context)!.homePageDrawerListTileHistory,
        ),
      ),
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
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            Navigator.of(context).pushReplacementNamed('/');
          case 1:
            Navigator.of(context).pushNamed('/favorite');
          case 2:
            Navigator.of(context).pushNamed('/history');
        }
      },
    );
  }

  Widget _buildBottomNavigationBar(
      BuildContext context, AuthenticationState state) {
    final notice = state.profile.notice;
    final noticeCount =
        notice.newPush + notice.newPrompt + notice.newPm + notice.newMyPost;
    return SalomonBottomBar(
      currentIndex: _index,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      onTap: (index) {
        setState(() {
          _index = index;
          _controller.animateToPage(
            _index,
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
          title:
              Text(AppLocalizations.of(context)!.homeBottomBarDestinationIndex),
        ),
        SalomonBottomBarItem(
          icon: const Icon(
            Icons.camera_outlined,
          ),
          activeIcon: const Icon(
            Icons.camera,
          ),
          title:
              Text(AppLocalizations.of(context)!.homeBottomBarDestinationGuide),
        ),
        SalomonBottomBarItem(
          icon: const Icon(
            Icons.dashboard_outlined,
          ),
          activeIcon: const Icon(
            Icons.dashboard,
          ),
          title:
              Text(AppLocalizations.of(context)!.homeBottomBarDestinationForum),
        ),
        SalomonBottomBarItem(
          icon: Badge(
            isLabelVisible: noticeCount > 0,
            child: const Icon(
              Icons.notifications_outlined,
            ),
          ),
          activeIcon: Badge(
            isLabelVisible: noticeCount > 0,
            child: const Icon(
              Icons.notifications,
            ),
          ),
          title: Text(
              AppLocalizations.of(context)!.homeBottomBarDestinationNotice),
        ),
      ],
    );
  }
}
