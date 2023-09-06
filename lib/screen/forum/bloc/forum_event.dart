part of 'forum_bloc.dart';

abstract class ForumEvent extends Equatable {
  const ForumEvent();

  @override
  List<Object?> get props => [];
}

class ForumRefreshed extends ForumEvent {
  final String? type;
  final String? filter;
  final Map<String, String>? params;
  final String? orderBy;

  const ForumRefreshed({this.type, this.filter, this.params, this.orderBy});

  @override
  List<Object?> get props => [type];
}

class ForumFetched extends ForumEvent {}
