import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/screen/space/bloc/space_friends_bloc.dart';
import 'package:keylol_flutter/widgets/avatar.dart';
import 'package:keylol_flutter/widgets/load_more_list_view.dart';

class SpaceFriendsView extends StatelessWidget {
  const SpaceFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpaceFriendsBloc, SpaceFriendsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final friends = state.friends;
        return RefreshIndicator(
          onRefresh: () async {
            context.read<SpaceFriendsBloc>().add(SpaceFriendsRefreshed());
          },
          child: LoadMoreListView(
            itemCount: friends.length + 1,
            itemBuilder: (context, index) {
              if (index == friends.length) {
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

              final friend = friends[index];

              return ListTile(
                leading: Avatar(
                  uid: friend.uid,
                  username: friend.username,
                  width: 32,
                  height: 32,
                ),
                title: Text(friend.username),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/space',
                    arguments: {
                      'uid',
                      friend.uid,
                    },
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              if (index == friends.length) {
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
              context.read<SpaceFriendsBloc>().add(SpaceFriendsFetched());
            },
          ),
        );
      },
    );
  }
}
