part of 'theme_color_bloc.dart';

class ThemeColorState extends Equatable {
  final Color color;

  const ThemeColorState(this.color);

  @override
  List<Object?> get props => [color];
}
