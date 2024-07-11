import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:keylol_flutter/repository/authentication_repository.dart';
import 'package:keylol_flutter/screen/thread/bloc/thread_bloc.dart';
import 'package:keylol_flutter/utils/text_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThreadAppBar extends SliverPersistentHeaderDelegate {
  final String tid;
  final String title;
  final bool favored;

  final TextStyle textStyle;
  final double width;

  final double titleHeight;
  final double topPadding;

  final favThreadTextController = TextEditingController();

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
          flexibleSpace: _buildFlexibleSpace(context, shrinkOffset),
          actions: _buildActions(context, state, title),
        );
      },
    );
  }

  Widget _buildFlexibleSpace(BuildContext context, double shrinkOffset) {
    return Container(
      margin: EdgeInsets.only(top: kToolbarHeight + topPadding),
      child: Stack(
        children: [
          Positioned(
            top: -shrinkOffset,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 20),
              width: width,
              child: Text(title, style: textStyle),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    AuthenticationState state,
    Widget? title,
  ) {
    List<Widget> actions = [];

    if (state.status == AuthenticationStatus.authenticated && title == null) {
      actions.add(IconButton(
        onPressed: () => _handleFavor(context),
        icon: favored ? const Icon(Icons.star) : const Icon(Icons.star_outline),
      ));
    }

    actions.add(PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => _buildPopmenuItems(context, state, title),
    ));

    return actions;
  }

  List<PopupMenuEntry> _buildPopmenuItems(
    BuildContext context,
    AuthenticationState state,
    Widget? title,
  ) {
    return [
      if (state.status == AuthenticationStatus.authenticated && title != null)
        PopupMenuItem(
          onTap: () => _handleFavor(context),
          child: Row(
            children: [
              favored ? const Icon(Icons.star) : const Icon(Icons.star_outline),
              favored
                  ? Text(AppLocalizations.of(context)!
                      .threadPageMenuRemoveFavorite)
                  : Text(
                      AppLocalizations.of(context)!.threadPageMenuAddFavorite),
            ],
          ),
        ),
      PopupMenuItem(
        child: Row(
          children: [
            const Icon(Icons.share),
            Text(AppLocalizations.of(context)!.threadPageMenuOpenInBrowser),
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
  }

  Future<void> _handleFavor(BuildContext context) async {
    final profile = context.read<AuthenticationRepository>().profile;
    if (favored) {
      context.read<ThreadBloc>().add(ThreadUnFavored(profile.formHash));
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title:
              Text(AppLocalizations.of(context)!.threadAddFavoriteDescription),
          content: TextField(
            controller: favThreadTextController,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  Text(AppLocalizations.of(context)!.threadAddFavoriteCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                context.read<ThreadBloc>().add(ThreadFavored(
                    profile.formHash, favThreadTextController.text));
                Navigator.pop(context);
              },
              child:
                  Text(AppLocalizations.of(context)!.threadAddFavoriteConfirm),
            ),
          ],
        ),
      );
    }
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
