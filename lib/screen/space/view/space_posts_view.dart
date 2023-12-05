import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/screen/space/bloc/space_posts_bloc.dart';
import 'package:keylol_flutter/widgets/load_more_list_view.dart';

class SpacePostsView extends StatelessWidget {
  const SpacePostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpacePostsBloc, SpacePostsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final posts = state.posts;
        return RefreshIndicator(
          onRefresh: () async {
            context.read<SpacePostsBloc>().add(SpacePostsRefreshed());
          },
          child: LoadMoreListView(
            itemCount: posts.length + 1,
            itemBuilder: (context, index) {
              if (index == posts.length) {
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

              final post = posts[index];

              return ListTile(
                title: Text(post.message),
                subtitle: Text(post.subject),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/thread',
                    arguments: {
                      'tid': post.tid,
                      'pid': post.pid,
                    },
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              if (index == posts.length) {
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
              context.read<SpacePostsBloc>().add(SpacePostsFetched());
            },
          ),
        );
      },
    );
  }
}
