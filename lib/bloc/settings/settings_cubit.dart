import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<DateTime> {
  SettingsCubit() : super(DateTime.now());

  void update() {
    emit(DateTime.now());
  }
}
