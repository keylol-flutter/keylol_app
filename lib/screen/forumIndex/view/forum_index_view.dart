import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/bloc/authentication_bloc.dart';
import 'package:keylol_flutter/screen/forumIndex/bloc/forum_index_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keylol_flutter/widgets/selectable_button.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ForumIndexView extends StatefulWidget {
  const ForumIndexView({super.key});

  @override
  State<StatefulWidget> createState() => _ForumIndexViewState();
}

class _ForumIndexViewState extends State<ForumIndexView> {
  int _currentCatIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        context.read<ForumIndexBloc>().add(ForumIndexFetched());
      },
      builder: (context, state) {
        return BlocConsumer<ForumIndexBloc, ForumIndexState>(
          listener: (context, state) {
            if (state.status == ForumIndexStatus.failure) {
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
            final forumIndex = state.status == ForumIndexStatus.initial
                ? ForumIndex.fromJson({
                    'catlist': List.generate(
                      10,
                      (index) => Cat.fromJson({
                        'name': 'Cat' * 4,
                        'forums': List.generate(10, (index) => '$index'),
                      }).toJson(),
                    ),
                    'forumlist': List.generate(
                      10,
                      (index) => Forum.fromJson({
                        'fid': '$index',
                        'name': 'Forum' * 2,
                        'description': 'Description' * 2,
                        'icon': '',
                      }).toJson(),
                    ),
                  })
                : state.forumIndex;
            if (forumIndex == null) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ForumIndexBloc>().add(ForumIndexFetched());
                },
                child: Container(),
              );
            }
            final catList = forumIndex.catList;
            final forumMap = forumIndex.forumMap;
            final currentCat = catList[_currentCatIndex];
            final currentForums = currentCat.forums;

            return Skeletonizer(
              enabled: state.status == ForumIndexStatus.initial,
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<ForumIndexBloc>().add(ForumIndexFetched());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: catList.length,
                          itemBuilder: (context, index) {
                            final cat = catList[index];
                            return SelectableButton(
                              selected: _currentCatIndex == index,
                              onPressed: () {
                                setState(() {
                                  _currentCatIndex = index;
                                });
                              },
                              child: Text(cat.name),
                            );
                          },
                        ),
                      ),
                      const VerticalDivider(),
                      Expanded(
                        flex: 2,
                        child: ListView.builder(
                          itemCount: currentForums.length,
                          itemBuilder: (context, index) {
                            final fid = currentForums[index];
                            final forum = forumMap[fid]!;
                            late Widget leading;
                            if (forum.icon.isEmpty) {
                              leading = Image.asset('images/forum.gif');
                            } else {
                              leading = Image.network(forum.icon);
                            }
                            return ListTile(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/forum',
                                  arguments: {'fid': fid},
                                );
                              },
                              leading: SizedBox(
                                width: 40.0,
                                height: 40.0,
                                child: ClipOval(
                                  child: leading,
                                ),
                              ),
                              title: Text(forum.name),
                              subtitle: Text(forum.description),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
