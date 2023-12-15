import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/repository/settings_repository.dart';

class SettingsCubit extends Cubit<DateTime> {
  final SettingsRepository _repository;
  late final StreamSubscription<DateTime> _streamSubscription;

  SettingsCubit(this._repository) : super(DateTime.now()) {
    _streamSubscription = _repository.version.listen((version) {
      emit(version);
    });
  }

  void dispose() {
    _streamSubscription.cancel();
  }
}
