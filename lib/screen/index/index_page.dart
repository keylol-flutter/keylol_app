import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol.dart';
import 'package:keylol_flutter/screen/index/bloc/index_bloc.dart';
import 'package:keylol_flutter/screen/index/bloc/search_bloc.dart';
import 'package:keylol_flutter/screen/index/view/index_view.dart';

class IndexPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const IndexPage({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => IndexBloc(context.read<Keylol>())..add(IndexFetched()),
        ),
        BlocProvider(
          create: (_) => SearchBloc(),
        ),
      ],
      child: IndexView(scaffoldKey: scaffoldKey),
    );
  }
}
