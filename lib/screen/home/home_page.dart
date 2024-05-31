import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:keylol_flutter/repository/authentication_repository.dart';
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

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  var _index = 0;
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          drawer: _buildDrawer(context, state),
          body: PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
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
    final destinations = [
      Padding(
        padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
        child: Text(
          AppLocalizations.of(context)!.homePageDrawerHeader,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
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
      if (state.status == AuthenticationStatus.authenticated)
        NavigationDrawerDestination(
          icon: const Icon(Icons.edit_outlined),
          label: Text(
            AppLocalizations.of(context)!.homePageDrawerListTileNewThread,
          ),
        ),
      const Padding(
        padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
        child: Divider(),
      ),
      NavigationDrawerDestination(
        icon: const Icon(Icons.settings_outlined),
        label: Text(
          AppLocalizations.of(context)!.homePageDrawerListTileSettings,
        ),
      ),
      NavigationDrawerDestination(
        icon: const Icon(Icons.logout_outlined),
        label: Text(
          AppLocalizations.of(context)!.homePageDrawerListTileLoginout,
        ),
      ),
    ];

    final onDestinationSelected = [
      () => Navigator.of(context).pushReplacementNamed('/'),
      () => Navigator.of(context).pushNamed('/favorite'),
      () => Navigator.of(context).pushNamed('/history'),
      if (state.status == AuthenticationStatus.authenticated)
        () => Navigator.of(context).pushNamed('/newThread'),
      () => Navigator.of(context).pushNamed('/settings'),
      () async {
        await context.read<Keylol>().cleanCookies();
        if (!context.mounted) return;
        context.read<AuthenticationBloc>().add(
            const AuthenticationStatusChanged(
                AuthenticationStatus.unauthenticated));
      }
    ];

    return NavigationDrawer(
      selectedIndex: -1,
      children: destinations,
      onDestinationSelected: (index) {
        if (index < onDestinationSelected.length) {
          onDestinationSelected[index].call();
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
