import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/screen/space/bloc/space_threads_bloc.dart';
import 'package:keylol_flutter/widgets/load_more_list_view.dart';

class SpaceThreadsView extends StatelessWidget {
  const SpaceThreadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpaceThreadsBloc, SpaceThreadsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final threads = state.threads;
        return RefreshIndicator(
          onRefresh: () async {
            context.read<SpaceThreadsBloc>().add(SpaceThreadsRefreshed());
          },
          child: LoadMoreListView(
            itemCount: threads.length + 1,
            itemBuilder: (context, index) {
              if (index == threads.length) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Opacity(
                    opacity: state.hasReachMax ? 0.0 : 1.0,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              final thread = threads[index];

              return ListTile(
                title: Text(thread.subject),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/thread',
                    arguments: {'tid': thread.tid},
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              if (index == threads.length) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Divider(
                  height: 0,
                  color: Theme.of(context).dividerColor.withOpacity(0.2),
                ),
              );
            },
            callback: () {
              context.read<SpaceThreadsBloc>().add(SpaceThreadsFetched());
            },
          ),
        );
      },
    );
  }
}
