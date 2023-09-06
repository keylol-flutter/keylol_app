import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/forum/bloc/forum_bloc.dart';
import 'package:keylol_flutter/screen/forum/view/forum_view.dart';

class ForumPage extends StatelessWidget {
  final String fid;

  const ForumPage({super.key, required this.fid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForumBloc(context.read<Keylol>(), fid)
        ..add(const ForumRefreshed()),
      child: const ForumView(),
    );
  }
}
