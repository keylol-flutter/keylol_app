import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/repository/favorite_repository.dart';
import 'package:keylol_flutter/screen/thread/bloc/thread_bloc.dart';
import 'package:keylol_flutter/screen/thread/view/thread_view.dart';

class ThreadPage extends StatelessWidget {
  final String tid;

  const ThreadPage({super.key, required this.tid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThreadBloc(
          context.read<Keylol>(), context.read<FavoriteRepository>(), tid)
        ..add(const ThreadRefreshed()),
      child: const ThreadView(),
    );
  }
}
