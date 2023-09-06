part of 'forum_bloc.dart';

enum ForumStatus { initial, success, failure }

class ForumState extends Equatable {
  final ForumStatus status;
  final Forum? forum;
  final List<Forum> subForums;
  final List<ThreadType> threadTypes;
  final String? type;
  final String? filter;
  final Map<String, String>? params;
  final String? orderBy;
  final List<Thread> threads;
  final int page;
  final bool hasReachMax;
  final String? message;

  const ForumState(
    this.status,
    this.forum,
    this.subForums,
    this.threadTypes,
    this.type,
    this.filter,
    this.params,
    this.orderBy,
    this.threads,
    this.page,
    this.hasReachMax,
    this.message,
  );

  ForumState copyWith({
    ForumStatus? status,
    Forum? forum,
    List<Forum>? subForums,
    List<ThreadType>? threadTypes,
    String? type,
    String? filter,
    Map<String, String>? params,
    String? orderBy,
    List<Thread>? threads,
    int? page,
    bool? hasReachMax,
    String? message,
  }) {
    return ForumState(
      status ?? this.status,
      forum ?? this.forum,
      subForums ?? this.subForums,
      threadTypes ?? this.threadTypes,
      type ?? this.type,
      filter ?? this.filter,
      params ?? this.params,
      orderBy ?? this.orderBy,
      threads ?? this.threads,
      page ?? this.page,
      hasReachMax ?? this.hasReachMax,
      message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        forum,
        subForums,
        threadTypes,
        type,
        filter,
        params,
        orderBy,
        threads,
        page,
        hasReachMax,
        message,
      ];
}

class ForumInitial extends ForumState {
  const ForumInitial()
      : super(
          ForumStatus.initial,
          null,
          const [],
          const [],
          null,
          null,
          null,
          null,
          const [],
          1,
          false,
          null,
        );
}
