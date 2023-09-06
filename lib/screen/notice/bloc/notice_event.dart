part of 'notice_bloc.dart';

abstract class NoticeEvent extends Equatable {
  const NoticeEvent();

  @override
  List<Object?> get props => [];
}

class NoticeRefreshed extends NoticeEvent {}

class NoticeFetched extends NoticeEvent {}
