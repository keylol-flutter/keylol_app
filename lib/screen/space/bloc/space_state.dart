part of 'space_bloc.dart';

enum SpaceStatus { initial, success, failure }

class SpaceState extends Equatable {
  final SpaceStatus status;

  final Profile? profile;
  final String? message;

  const SpaceState(this.status, this.profile, this.message);

  SpaceState copyWith({
    SpaceStatus? status,
    Profile? profile,
    String? message,
  }) {
    return SpaceState(
      status ?? this.status,
      profile ?? this.profile,
      message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, profile, message];
}

class SpaceInitial extends SpaceState {
  const SpaceInitial() : super(SpaceStatus.initial, null, null);
}
