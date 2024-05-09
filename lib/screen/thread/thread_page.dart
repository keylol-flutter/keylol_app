import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/repository/favorite_repository.dart';
import 'package:keylol_flutter/screen/thread/bloc/thread_bloc.dart';
import 'package:keylol_flutter/screen/thread/view/thread_view.dart';

class ThreadPage extends StatelessWidget {
  final String tid;
  final String? pid;
  final Thread? thread;

  const ThreadPage({
    super.key,
    required this.tid,
    this.pid,
    this.thread,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThreadBloc(
          context.read<Keylol>(), context.read<FavoriteRepository>(), tid)
        ..add(ThreadRefreshed(pid: pid)),
      child: const ThreadView(),
    );
  }
}
