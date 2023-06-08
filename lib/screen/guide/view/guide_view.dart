import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/bloc/bloc/authentication_bloc.dart';
import 'package:keylol_flutter/screen/guide/bloc/guide_bloc.dart';
import 'package:keylol_flutter/widgets/avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GuideView extends StatefulWidget {
  const GuideView({super.key});

  @override
  State<StatefulWidget> createState() => _GuideViewState();
}

class _GuideViewState extends State<GuideView> {
  final _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(() {
      final maxScroll = _controller.position.maxScrollExtent;
      final pixels = _controller.position.pixels;

      if (maxScroll == pixels) {
        context.read<GuideBloc>().add(GuideFetched());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        context.read<GuideBloc>().add(GuideRefreshed());
      },
      builder: (context, state) {
        return BlocConsumer<GuideBloc, GuideState>(
          listener: (context, state) {
            if (state.status == GuideStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.networkError),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final threads = state.threads;
            if (threads.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GuideBloc>().add(GuideRefreshed());
              },
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                controller: _controller,
                physics: const AlwaysScrollableScrollPhysics(),
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
                      width: 40.0,
                      height: 40.0,
                    ),
                    title: Text(
                      thread.subject,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      '${thread.author} • ${thread.dateline}',
                      style: Theme.of(context).textTheme.bodyMedium,
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
                  return const Divider(thickness: 1);
                },
              ),
            );
          },
        );
      },
    );
  }
}
