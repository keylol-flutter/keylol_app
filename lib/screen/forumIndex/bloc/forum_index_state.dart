part of 'forum_index_bloc.dart';

enum ForumIndexStatus {
  initial,
  success,
  failure;

  static ForumIndexStatus fromName(String name) =>
      ForumIndexStatus.values.firstWhere((e) => e.name == name);
}

class ForumIndexState extends Equatable {
  final ForumIndexStatus status;
  final ForumIndex? forumIndex;
  final String? message;

  const ForumIndexState(this.status, this.forumIndex, this.message);

  ForumIndexState copyWith({
    ForumIndexStatus? status,
    ForumIndex? forumIndex,
    String? message,
  }) {
    return ForumIndexState(
      status ?? this.status,
      forumIndex ?? this.forumIndex,
      message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, forumIndex, message];

  factory ForumIndexState.fromJson(Map<String, dynamic> json) =>
      ForumIndexState(
        ForumIndexStatus.fromName(json['status']),
        json['forumIndex'] == null
            ? null
            : ForumIndex.fromJson(json['forumIndex']),
        json['message'],
      );

  Map<String, dynamic> toJson() => {
        'status': status.name,
        'forumIndex': forumIndex?.toJson(),
        'message': message,
      };
}

class ForumIndexInitial extends ForumIndexState {
  const ForumIndexInitial() : super(ForumIndexStatus.initial, null, null);
}
