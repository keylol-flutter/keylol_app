import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:keylol_flutter/repository/authentication_repository.dart';
import 'package:keylol_flutter/screen/guide/bloc/guide_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keylol_flutter/widgets/load_more_list_view.dart';
import 'package:keylol_flutter/widgets/thread_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GuideView<B extends GuideBloc> extends StatelessWidget {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        context.read<B>().add(GuideRefreshed());
      },
      builder: (context, state) {
        final authenticationStatus = state.status;
        return BlocConsumer<B, GuideState>(
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
            final threads = state.status == GuideStatus.initial
                ? List.generate(
                    20,
                    (index) => Thread.fromJson({
                      'subject': 'Subject' * 4,
                      'author': 'Author',
                      'authorid': '0',
                      'dateline': '1970-01-01',
                    }),
                  )
                : state.threads;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<B>().add(GuideRefreshed());
              },
              child: Skeletonizer(
                enabled: state.status == GuideStatus.initial,
                child: LoadMoreListView(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  callback: () {
                    context.read<B>().add(GuideFetched());
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

                    return ThreadItem(thread: threads[index]);
                  },
                  separatorBuilder: (context, index) {
                    if (index == threads.length) {
                      return Container();
                    }
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0 + 56, right: 16.0),
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
      },
    );
  }
}
