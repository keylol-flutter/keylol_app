part of 'guide_bloc.dart';

abstract class GuideEvent extends Equatable {
  const GuideEvent();

  @override
  List<Object?> get props => [];
}

class GuideRefreshed extends GuideEvent {}

class GuideFetched extends GuideEvent{}

