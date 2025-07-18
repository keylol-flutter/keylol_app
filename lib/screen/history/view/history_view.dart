import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/screen/history/bloc/history_bloc.dart';
import 'package:keylol_flutter/widgets/load_more_list_view.dart';
import 'package:keylol_flutter/widgets/thread_item.dart';
import 'package:keylol_flutter/l10n/app_localizations.dart';
import 'package:sticky_headers/sticky_headers.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryState();
}

class _HistoryState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.homePageDrawerListTileHistory,
        ),
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          final dateThreadMap = state.threads;
          final dates = dateThreadMap.keys.toList();
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HistoryBloc>().add(HistoryRefreshed());
            },
            child: LoadMoreListView(
              callback: () {
                context.read<HistoryBloc>().add(HistoryFetched());
              },
              itemCount: dates.length,
              itemBuilder: (context, index) {
                final threads = dateThreadMap[dates[index]] ?? [];
                return StickyHeaderBuilder(
                  builder: (context, stuckAmount) {
                    return Container(
                      height: 50,
                      color: stuckAmount == -1
                          ? ElevationOverlay.applySurfaceTint(
                              Theme.of(context).colorScheme.surface,
                              Theme.of(context).colorScheme.surfaceTint,
                              3,
                            )
                          : Theme.of(context).colorScheme.background,
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        dates[index],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    );
                  },
                  content: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: threads.length,
                    itemBuilder: (context, index) {
                      final thread = threads[index];
                      return ThreadItem(thread: thread);
                    },
                    separatorBuilder: (context, index) {
                      if (index == threads.length - 1) {
                        return Container();
                      }
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 16.0 + 56, right: 16.0),
                        child: Divider(
                          height: 0,
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.2),
                        ),
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container();
              },
            ),
          );
        },
      ),
    );
  }
}
