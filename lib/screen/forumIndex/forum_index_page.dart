import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/forumIndex/bloc/forum_index_bloc.dart';
import 'package:keylol_flutter/screen/forumIndex/view/forum_index_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForumIndexPage extends StatelessWidget {
  const ForumIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ForumIndexBloc(context.read<Keylol>())..add(ForumIndexFetched()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () async {
              Scaffold.of(context).openDrawer();
            },
          ),
          title: Text(AppLocalizations.of(context)!.forumIndexPageTitle),
        ),
        body: const ForumIndexView(),
      ),
    );
  }
}
