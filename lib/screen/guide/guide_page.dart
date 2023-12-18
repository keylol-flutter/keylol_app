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
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  HotGuideBloc(context.read<Keylol>())..add(GuideRefreshed()),
            ),
            BlocProvider(
              create: (context) => DigestGuideBloc(context.read<Keylol>())
                ..add(GuideRefreshed()),
            ),
            BlocProvider(
              create: (context) => NewThreadGuideBloc(context.read<Keylol>())
                ..add(GuideRefreshed()),
            ),
            BlocProvider(
              create: (context) =>
                  NewGuideBloc(context.read<Keylol>())..add(GuideRefreshed()),
            ),
            BlocProvider(
              create: (context) =>
                  SofaGuideBloc(context.read<Keylol>())..add(GuideRefreshed()),
            ),
          ],
          child: const TabBarView(
            children: [
              GuideView<HotGuideBloc>(),
              GuideView<DigestGuideBloc>(),
              GuideView<NewThreadGuideBloc>(),
              GuideView<NewGuideBloc>(),
              GuideView<SofaGuideBloc>(),
            ],
          ),
        ),
      ),
    );
  }
}
