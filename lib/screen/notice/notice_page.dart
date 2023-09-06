import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/notice/bloc/notice_bloc.dart';
import 'package:keylol_flutter/screen/notice/view/notice_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoticeBloc(context.read<Keylol>())..add(NoticeRefreshed()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () async {
              Scaffold.of(context).openDrawer();
            },
          ),
          title: Text(AppLocalizations.of(context)!.noticePageTitle),
        ),
        body: const NoticeView(),
      ),
    );
  }
}
