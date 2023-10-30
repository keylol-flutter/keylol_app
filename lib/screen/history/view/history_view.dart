import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/screen/history/bloc/history_bloc.dart';
import 'package:keylol_flutter/widgets/load_more_list_view.dart';
import 'package:keylol_flutter/widgets/thread_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryState();
}

class _HistoryState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        final threads = state.threads;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.homePageDrawerListTileHistory,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<HistoryBloc>().add(HistoryRefreshed());
            },
            child: LoadMoreListView(
              callback: () {
                context.read<HistoryBloc>().add(HistoryFetched());
              },
              itemCount: threads.length + 1,
              itemBuilder: (context, index) {
                return ThreadItem(thread: threads[index]);
              },
              separatorBuilder: (context, index) {
                if (index == threads.length - 1) {
                  return Container();
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0 + 56, right: 16.0),
                  child: Divider(
                    height: 0,
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
