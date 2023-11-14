import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol.dart';
import 'package:keylol_flutter/screen/space/bloc/space_bloc.dart';
import 'package:keylol_flutter/screen/space/view/space_view.dart';

class SpacePage extends StatelessWidget {
  final String uid;

  const SpacePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SpaceBloc(context.read<Keylol>(), uid)..add(SpaceRefreshed()),
      child: const SpaceView(),
    );
  }
}
