import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/bloc/authentication_bloc.dart';
import 'package:keylol_flutter/screen/notice/bloc/notice_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keylol_flutter/widgets/avatar.dart';
import 'package:keylol_flutter/widgets/load_more_list_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NoticeView extends StatefulWidget {
  const NoticeView({super.key});

  @override
  State<StatefulWidget> createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
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
                      'note': 'Note',
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
                    final date = DateTime.fromMillisecondsSinceEpoch(
                        notice.dateline * 1000);
                    return ListTile(
                      onTap: () {
                        if (notice.noteVar != null) {
                          final noteVar = notice.noteVar;
                          Navigator.of(context).pushNamed(
                            '/thread',
                            arguments: {
                              'tid': noteVar?.tid,
                              'pid': noteVar?.pid,
                            },
                          );
                        }
                      },
                      leading: Avatar(
                        key: Key('Avatar${notice.authorId}'),
                        uid: notice.authorId,
                        username: notice.author,
                      ),
                      title: Html(
                        shrinkWrap: true,
                        data: notice.note..replaceAll('&nsbp;', ''),
                        extensions: [
                          TagExtension(
                              tagsToExtend: {'a', 'blockquote'},
                              builder: (context) {
                                return Text(context.innerHtml);
                              }),
                        ],
                        style: {
                          'body': Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(
                              Theme.of(context).textTheme.bodyLarge!.fontSize!,
                            ),
                          )
                        },
                      ),
                      subtitle:
                          Text(formatDate(date, [yyyy, '-', mm, '-', dd])),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(height: 0);
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
