import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger.dart';

part 'notice_event.dart';

part 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final Keylol _client;

  NoticeBloc(this._client) : super(const NoticeInitial()) {
    on<NoticeRefreshed>(_onNoticeRefreshed);
    on<NoticeFetched>(_onNoticeFetched);
  }

  Future<void> _onNoticeRefreshed(
    NoticeRefreshed event,
    Emitter<NoticeState> emit,
  ) async {
    try {
      final myNoteListResp = await _client.myNoteList(0);
      final message = myNoteListResp.message;
      if (message != null) {
        emit(state.copyWith(
          status: NoticeStatus.failure,
          message: message.messageStr,
        ));
        return;
      }

      final myNoteList = myNoteListResp.variables;
      final notices = myNoteList.list;
      final count = myNoteList.count;

      emit(state.copyWith(
        status: NoticeStatus.success,
        notices: notices,
        page: 1,
        hasReachMax: notices.length >= count,
        message: null,
      ));
    } catch (e, stack) {
      logger.e('加载通知列表失败', e, stack);
      emit(state.copyWith(status: NoticeStatus.failure));
    }
  }

  Future<void> _onNoticeFetched(
    NoticeFetched event,
    Emitter<NoticeState> emit,
  ) async {
    final page = state.page + 1;
    try {
      final myNoteListResp = await _client.myNoteList(page);
      final message = myNoteListResp.message;
      if (message != null) {
        emit(state.copyWith(
          status: NoticeStatus.failure,
          message: message.messageStr,
        ));
        return;
      }

      final myNoteList = myNoteListResp.variables;
      final notices = myNoteList.list;
      emit(state.copyWith(
        status: NoticeStatus.success,
        notices: state.notices..addAll(notices),
        page: page,
        hasReachMax: notices.length < myNoteList.perPage,
        message: null,
      ));
    } catch (e, stack) {
      logger.e('加载通知列表失败', e, stack);
      emit(state.copyWith(status: NoticeStatus.failure));
    }
  }
}
