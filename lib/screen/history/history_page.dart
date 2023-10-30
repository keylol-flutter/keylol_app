import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/repository/history_repository.dart';
import 'package:keylol_flutter/screen/history/bloc/history_bloc.dart';
import 'package:keylol_flutter/screen/history/view/history_view.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryBloc(context.read<HistoryRepository>())
        ..add(HistoryRefreshed()),
      child: const HistoryView(),
    );
  }
}
