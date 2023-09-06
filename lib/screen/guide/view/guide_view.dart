import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/bloc/bloc/authentication_bloc.dart';
import 'package:keylol_flutter/repository/authentication_repository.dart';
import 'package:keylol_flutter/screen/guide/bloc/guide_bloc.dart';
import 'package:keylol_flutter/widgets/avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keylol_flutter/widgets/load_more_list_view.dart';

class GuideView extends StatelessWidget {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        context.read<GuideBloc>().add(GuideRefreshed());
      },
      builder: (context, state) {
        final authenticationStatus = state.status;
        return BlocConsumer<GuideBloc, GuideState>(
          listener: (context, state) {
            if (state.status == GuideStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: authenticationStatus ==
                          AuthenticationStatus.unauthenticated
                      ? Text(AppLocalizations.of(context)!.notLoginError)
                      : Text(AppLocalizations.of(context)!.networkError),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final threads = state.threads;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GuideBloc>().add(GuideRefreshed());
              },
              child: LoadMoreListView(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                physics: const AlwaysScrollableScrollPhysics(),
                callback: () {
                  context.read<GuideBloc>().add(GuideFetched());
                },
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
                    leading: Avatar(
                      key: Key('Avatar ${thread.authorId}'),
                      uid: thread.authorId,
                      username: thread.author,
                    ),
                    title: Text(
                      thread.subject,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(thread.author,
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(thread.dateline,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/thread',
                        arguments: {'tid': thread.tid},
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(height: 0);
                },
              ),
            );
          },
        );
      },
    );
  }
}
