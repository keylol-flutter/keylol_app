import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:keylol_flutter/repository/config_repository.dart';

part 'theme_color_event.dart';

part 'theme_color_state.dart';

class ThemeColorBloc extends Bloc<ThemeColorEvent, ThemeColorState> {
  final ConfigRepository _configRepository;

  ThemeColorBloc(this._configRepository)
      : super(ThemeColorState(Color(_configRepository.getThemeColorValue()))) {
    on<ThemeColorUpdated>((event, emit) {
      final color = event.color;
      _configRepository.setThemeColor(color.value);
      emit(ThemeColorState(color));
    });
  }
}
