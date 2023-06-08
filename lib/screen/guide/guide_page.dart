import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/guide/bloc/guide_bloc.dart';
import 'package:keylol_flutter/screen/guide/view/guide_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () async {
              Scaffold.of(context).openDrawer();
            },
          ),
          title: Text(AppLocalizations.of(context)!.guidePageTitle),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.guidePageTabHot),
              Tab(text: AppLocalizations.of(context)!.guidePageTabDigest),
              Tab(text: AppLocalizations.of(context)!.guidePageTabNewThread),
              Tab(text: AppLocalizations.of(context)!.guidePageTabNew),
              Tab(text: AppLocalizations.of(context)!.guidePageTabSofa),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider(
              create: (context) => GuideBloc(context.read<Keylol>(), 'hot')
                ..add(GuideRefreshed()),
              child: const GuideView(),
            ),
            BlocProvider(
              create: (context) => GuideBloc(context.read<Keylol>(), 'digest')
                ..add(GuideRefreshed()),
              child: const GuideView(),
            ),
            BlocProvider(
              create: (context) =>
                  GuideBloc(context.read<Keylol>(), 'newthread')
                    ..add(GuideRefreshed()),
              child: const GuideView(),
            ),
            BlocProvider(
              create: (context) => GuideBloc(context.read<Keylol>(), 'new')
                ..add(GuideRefreshed()),
              child: const GuideView(),
            ),
            BlocProvider(
              create: (context) => GuideBloc(context.read<Keylol>(), 'sofa')
                ..add(GuideRefreshed()),
              child: const GuideView(),
            ),
          ],
        ),
      ),
    );
  }
}
