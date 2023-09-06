part of 'forum_index_bloc.dart';

enum ForumIndexStatus { initial, success, failure }

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
}

class ForumIndexInitial extends ForumIndexState {
  const ForumIndexInitial() : super(ForumIndexStatus.initial, null, null);
}
