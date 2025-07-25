import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/screen/favorite/bloc/favorite_bloc.dart';
import 'package:keylol_flutter/screen/favorite/widgets/favorite_thread_item.dart';
import 'package:keylol_flutter/widgets/load_more_list_view.dart';
import 'package:keylol_flutter/l10n/app_localizations.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<StatefulWidget> createState() => _FavoriteState();
}

class _FavoriteState extends State<FavoriteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.homePageDrawerListTileFavorite,
        ),
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          final favThreads = state.favThreads;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FavoriteBloc>().add(FavoriteRefreshed());
            },
            child: LoadMoreListView(
              itemCount: favThreads.length + 1,
              itemBuilder: (context, index) {
                if (index == favThreads.length) {
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

                final favThread = favThreads[index];
                return FavoriteThreadItem(favThread: favThread);
              },
              separatorBuilder: (context, index) {
                if (index == favThreads.length - 1) {
                  return Container();
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Divider(
                    height: 0,
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.2),
                  ),
                );
              },
              callback: () {
                context.read<FavoriteBloc>().add(FavoriteFetched());
              },
            ),
          );
        },
      ),
    );
  }
}
