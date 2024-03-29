import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:keylol_flutter/repository/authentication_repository.dart';
import 'package:keylol_flutter/screen/thread/bloc/thread_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Size boundingTextSize(String text, TextStyle style,
    {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
  final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: text, style: style),
      maxLines: maxLines)
    ..layout(maxWidth: maxWidth);
  return textPainter.size;
}

class ThreadAppBar extends SliverPersistentHeaderDelegate {
  final String tid;
  final String title;
  final bool favored;

  final TextStyle textStyle;
  final double width;

  final double titleHeight;
  final double topPadding;

  ThreadAppBar({
    required this.tid,
    required this.title,
    required this.favored,
    required this.textStyle,
    required this.width,
    required this.topPadding,
  }) : titleHeight =
            boundingTextSize(title, textStyle, maxWidth: width - 32.0).height;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    double toolbarOpacity = maxExtent == minExtent
        ? 0.0
        : ((maxExtent - minExtent - shrinkOffset) / (maxExtent - minExtent))
            .clamp(0.0, 1.0);

    final title = toolbarOpacity == 0.0 ? Text(this.title) : null;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return AppBar(
          title: title,
          flexibleSpace: Container(
            margin: EdgeInsets.only(top: kToolbarHeight + topPadding),
            child: Stack(
              children: [
                Positioned(
                  top: -shrinkOffset,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 20),
                    width: width,
                    child: Text(this.title, style: textStyle),
                  ),
                )
              ],
            ),
          ),
          actions: [
            if (state.status == AuthenticationStatus.authenticated &&
                title == null)
              IconButton(
                onPressed: () {
                  final profile =
                      context.read<AuthenticationRepository>().profile;
                  if (favored) {
                    context
                        .read<ThreadBloc>()
                        .add(ThreadUnFavored(profile.formHash));
                  } else {
                    _favThread(context, profile.formHash);
                  }
                },
                icon: favored
                    ? const Icon(Icons.star)
                    : const Icon(Icons.star_outline),
              ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) {
                return [
                  if (state.status == AuthenticationStatus.authenticated &&
                      title != null)
                    PopupMenuItem(
                      child: Row(
                        children: [
                          favored
                              ? const Icon(Icons.star)
                              : const Icon(Icons.star_outline),
                          favored
                              ? Text(AppLocalizations.of(context)!
                                  .threadPageMenuRemoveFavorite)
                              : Text(AppLocalizations.of(context)!
                                  .threadPageMenuAddFavorite),
                        ],
                      ),
                      onTap: () {
                        final profile =
                            context.read<AuthenticationRepository>().profile;
                        if (favored) {
                          context
                              .read<ThreadBloc>()
                              .add(ThreadUnFavored(profile.formHash));
                        } else {
                          _favThread(context, profile.formHash);
                        }
                      },
                    ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        const Icon(Icons.share),
                        Text(AppLocalizations.of(context)!
                            .threadPageMenuOpenInBrowser),
                      ],
                    ),
                    onTap: () {
                      launchUrlString(
                        'https://keylol.com/t$tid-1-1',
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  )
                ];
              },
            ),
          ],
        );
      },
    );
  }

  void _favThread(BuildContext context, String formHash) {
    final controller = TextEditingController();
    final dialog = AlertDialog(
      title: Text(AppLocalizations.of(context)!.threadAddFavoriteDescription),
      content: TextField(
        controller: controller,
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.threadAddFavoriteCancel),
        ),
        ElevatedButton(
          onPressed: () async {
            context
                .read<ThreadBloc>()
                .add(ThreadFavored(formHash, controller.text));
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.threadAddFavoriteConfirm),
        ),
      ],
    );

    showDialog(context: context, builder: (context) => dialog);
  }

  @override
  double get maxExtent => kToolbarHeight + topPadding + titleHeight + 20;

  @override
  double get minExtent => kToolbarHeight + topPadding;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
