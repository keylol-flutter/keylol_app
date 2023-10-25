part of 'thread_bloc.dart';

enum ThreadStatus { initial, success, failure }

class ThreadState extends Equatable {
  final ThreadStatus status;
  final Thread? thread;
  final Post? firstPost;

  final int page;
  final List<Post> posts;
  final bool hasReachMax;

  final SpecialPoll? poll;

  final String? message;

  const ThreadState(
    this.status,
    this.thread,
    this.firstPost,
    this.page,
    this.posts,
    this.hasReachMax,
    this.message,
    this.poll,
  );

  ThreadState copyWith({
    ThreadStatus? status,
    Thread? thread,
    Post? firstPost,
    int? page,
    List<Post>? posts,
    bool? hasReachMax,
    String? message,
    SpecialPoll? poll,
  }) {
    return ThreadState(
      status ?? this.status,
      thread ?? this.thread,
      firstPost ?? this.firstPost,
      page ?? this.page,
      posts ?? this.posts,
      hasReachMax ?? this.hasReachMax,
      message ?? this.message,
      poll ?? this.poll,
    );
  }

  @override
  List<Object?> get props => [
        status,
        thread,
        firstPost,
        page,
        posts,
        hasReachMax,
        poll,
        message,
      ];
}

class ThreadInitial extends ThreadState {
  ThreadInitial() : super(ThreadStatus.initial, null, null, 1, [], false, null, null);
}
