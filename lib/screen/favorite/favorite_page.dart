import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol.dart';
import 'package:keylol_flutter/screen/favorite/bloc/favorite_bloc.dart';
import 'package:keylol_flutter/screen/favorite/view/favorite_view.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          FavoriteBloc(context.read<Keylol>())..add(FavoriteRefreshed()),
      child: const FavoriteView(),
    );
  }
}
