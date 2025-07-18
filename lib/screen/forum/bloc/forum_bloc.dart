import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger.dart';

part 'forum_event.dart';

part 'forum_state.dart';

class ForumBloc extends Bloc<ForumEvent, ForumState> {
  final Keylol _client;
  final String fid;

  ForumBloc(this._client, this.fid) : super(const ForumInitial()) {
    on<ForumRefreshed>(_onForumRefreshed);
    on<ForumFetched>(_onForumFetched);
  }

  Future<void> _onForumRefreshed(
    ForumRefreshed event,
    Emitter<ForumState> emit,
  ) async {
    try {
      final type = event.type;
      final filter = event.filter;
      final params = event.params ?? {};
      final orderBy = event.orderBy;

      final queryParams = <String, String>{};
      queryParams.addAll(params);
      if (orderBy != null) {
        queryParams['orderby'] = orderBy;
      }

      final forumDisplayResp =
          await _client.forumDisplay(fid, filter, type, queryParams, 1);
      final message = forumDisplayResp.message;
      if (message != null) {
        emit(state.copyWith(
          status: ForumStatus.failure,
          message: message.messageStr,
        ));
      }

      final forumDisplay = forumDisplayResp.variables;
      final forum = forumDisplay.forum;
      final subForums = forumDisplay.subList;
      final threadTypes = forumDisplay.threadTypes;
      final threads = forumDisplay.forumThreadList;
      emit(ForumState(
        ForumStatus.success,
        forum,
        subForums,
        threadTypes,
        type,
        filter,
        params,
        orderBy,
        threads,
        1,
        threads.length < 20,
        null,
      ));
    } catch (e, stack) {
      talker.error('加载版块信息失败: $fid', e, stack);
      emit(state.copyWith(status: ForumStatus.failure));
    }
  }

  Future<void> _onForumFetched(
    ForumFetched event,
    Emitter<ForumState> emit,
  ) async {
    try {
      final page = state.page + 1;
      final type = state.type;
      final filter = state.filter;
      final params = state.params ?? {};
      final orderBy = state.orderBy;

      final queryParams = <String, String>{};
      queryParams.addAll(params);
      if (orderBy != null) {
        queryParams['orderby'] = orderBy;
      }

      final forumDisplayResp =
          await _client.forumDisplay(fid, filter, type, queryParams, page);
      final message = forumDisplayResp.message;
      if (message != null) {
        emit(state.copyWith(
          status: ForumStatus.failure,
          message: message.messageStr,
        ));
      }

      final forumDisplay = forumDisplayResp.variables;
      final threads = forumDisplay.forumThreadList;
      emit(state.copyWith(
        status: ForumStatus.success,
        threads: state.threads..addAll(threads),
        page: page,
        hasReachMax: threads.length < 20,
      ));
    } catch (e, stack) {
      talker.error('加载版块信息失败: $fid', e, stack);
      emit(state.copyWith(status: ForumStatus.failure));
    }
  }
}

class TypeForumBloc extends ForumBloc {
  TypeForumBloc(super.client, super.fid);
}
