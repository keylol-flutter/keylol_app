import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:keylol_flutter/screen/notice/bloc/notice_bloc.dart';
import 'package:keylol_flutter/l10n/app_localizations.dart';
import 'package:keylol_flutter/screen/notice/widgets/notice_item.dart';
import 'package:keylol_flutter/widgets/load_more_list_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NoticeView extends StatefulWidget {
  const NoticeView({super.key});

  @override
  State<StatefulWidget> createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  @override
  void initState() {
    super.initState();

    context.read<NoticeBloc>().add(NoticeRefreshed());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        context.read<NoticeBloc>().add(NoticeRefreshed());
      },
      builder: (context, state) {
        return BlocConsumer<NoticeBloc, NoticeState>(
          listener: (context, state) {
            if (state.status == NoticeStatus.failure) {
              final message =
                  state.message ?? AppLocalizations.of(context)!.networkError;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final notices = state.status == NoticeStatus.initial
                ? List.generate(
                    20,
                    (index) => Note.fromJson({
                      'authorid': '0',
                      'author': 'Author',
                      'note': 'Note' * 10,
                      'dateline': '1700000000',
                    }),
                  )
                : state.notices;
            return Skeletonizer(
              enabled: state.status == NoticeStatus.initial,
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<NoticeBloc>().add(NoticeRefreshed());
                },
                child: LoadMoreListView(
                  callback: () {
                    context.read<NoticeBloc>().add(NoticeFetched());
                  },
                  itemCount: notices.length + 1,
                  itemBuilder: (context, index) {
                    if (index == notices.length) {
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

                    final notice = notices[index];
                    return NoticeItem(notice: notice);
                  },
                  separatorBuilder: (context, index) {
                    if (index == notices.length) {
                      return Container();
                    }
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0 + 56, right: 16.0),
                      child: Divider(
                        height: 0,
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.2),
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
