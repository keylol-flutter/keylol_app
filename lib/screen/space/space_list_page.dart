import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/space/bloc/space_friends_bloc.dart';
import 'package:keylol_flutter/screen/space/bloc/space_posts_bloc.dart';
import 'package:keylol_flutter/screen/space/bloc/space_threads_bloc.dart';
import 'package:keylol_flutter/screen/space/view/space_friends_view.dart';
import 'package:keylol_flutter/screen/space/view/space_posts_view.dart';
import 'package:keylol_flutter/screen/space/view/space_threads_view.dart';
import 'package:keylol_flutter/l10n/app_localizations.dart';

class SpaceListPage extends StatelessWidget {
  final String uid;
  final int? initialIndex;

  const SpaceListPage({super.key, required this.uid, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SpaceFriendsBloc(context.read<Keylol>(), uid)
            ..add(SpaceFriendsRefreshed()),
        ),
        BlocProvider(
          create: (_) => SpaceThreadsBloc(context.read<Keylol>(), uid)
            ..add(SpaceThreadsRefreshed()),
        ),
        BlocProvider(
          create: (_) => SpacePostsBloc(context.read<Keylol>(), uid)
            ..add(SpacePostsRefreshed()),
        ),
      ],
      child: DefaultTabController(
        length: 3,
        initialIndex: initialIndex ?? 0,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: AppLocalizations.of(context)!.spacePageFriendsTab),
                Tab(text: AppLocalizations.of(context)!.spacePageThreadsTab),
                Tab(text: AppLocalizations.of(context)!.spacePagePostsTab),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              SpaceFriendsView(),
              SpaceThreadsView(),
              SpacePostsView(),
            ],
          ),
        ),
      ),
    );
  }
}
